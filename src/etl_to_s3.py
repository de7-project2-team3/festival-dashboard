import os
import re
import time
import datetime
import requests
import pandas as pd
from dotenv import load_dotenv


env_path = os.path.join(os.path.dirname(__file__), "..", ".env")
load_dotenv(env_path)


# ==================================================
# 수집
# ==================================================

# OpenAPI를 통한 데이터 수집
# API 1회 호출시 최대 1000건의 데이터 요청 가능
def extract_culture_events(api_key: str, start: int = 1, end: int = 1000) -> tuple[pd.DataFrame, int]:
    # api 요청주소
    base_url = "http://openapi.seoul.go.kr:8088"
    service_name = "culturalEventInfo"
    url = f"{base_url}/{api_key}/json/{service_name}/{start}/{end}"
    
    try:
        response = requests.get(url, timeout=10)
        response.raise_for_status()
        data = response.json()
        
        # 해당 호출 구간에 더이상 데이터가 없을 경우 (INFO-200 메시지)
        if "RESULT" in data and data["RESULT"].get("CODE") == "INFO-200":
            print(f"[{start}~{end}] 데이터 없음")
            return pd.DataFrame()
        
        # 응답 구조에 이상이 있을 경우
        if "row" not in data[service_name]:
            print(f"예상치 못한 응답 구조 ({start}~{end})")
            print(data)
            return pd.DataFrame()
        
        rows = data[service_name]["row"]
        df = pd.DataFrame(rows)
        return df
    
    except Exception as e:
        print(f"API 호출 실패 - {e}")
        return pd.DataFrame()
    
# API 반복 호출로 전체 데이터 추출
def extract_all_culture_events(api_key: str):
    all_data = []
    part = 1000
    start = 1
    
    while True:
        end = start + part - 1
        print(f"[{start}~{end}] 수집 중...")
        
        df_part = extract_culture_events(api_key, start, end)
        
        # 해당 호출 구간에 대해 빈 df가 반환될 경우 => 전체 페이징 완료
        if df_part.empty:
            print("수집 종료")
            break
        
        all_data.append(df_part)
        start += part
        time.sleep(0.2)  # API 서버 과부하 방지
        
    if not all_data:
        print("수집된 데이터가 없습니다")
        return pd.DataFrame()
    
    df_all = pd.concat(all_data, ignore_index=True)
    print(f"원본 데이터 갯수: {len(df_all)}")
    return df_all


# ==================================================
# 전처리
# ==================================================

# 전체 데이터 전처리
def clean_culture_event_data(df: pd.DataFrame) -> pd.DataFrame:
    
    # 컬럼명 수정 및 필요한 컬럼만 유지
    rename_map = {
        "CODENAME": "CATEGORY",
        "GUNAME": "DISTRICT",
        "TITLE": "TITLE",
        # "DATE": "date_range",
        "STRTDATE": "START_DATE",
        "END_DATE": "END_DATE",
        # "PRO_TIME": "performance_time",
        "PLACE": "PLACE",
        "LOT": "LATITUDE",  # 위도 (원본데이터에 반대로 저장되어 있음)
        "LAT": "LONGITUDE", # 경도 (원본데이터에 반대로 저장되어 있음)
        "ORG_NAME": "ORGANIZATION",
        # "USE_TRGT": "target",
        # "PROGRAM": "program",
        # "PLAYER": "performer",
        # "ETC_DESC": "description",
        # "THEMECODE": "theme",
        "TICKET": "SUBJECT",
        "IS_FREE": "IS_FREE",
        # "USE_FEE": "fee",
        # "MAIN_IMG": "image_url",
        # "ORG_LINK": "organizer_link",
        "HMPG_ADDR": "URL",
        "RGSTDATE": "REGISTERED"
    }
    df.rename(columns=rename_map, inplace=True)
    cols = list(rename_map.values())
    df = df[[c for c in cols if c in df.columns]]
    
    # 고유ID 컬럼 추가
    # 상세 URL에서 cultcode 추출
    def extract_event_id(url):
        if pd.isna(url) or url.strip() == '':
            return None
        match = re.search(r'cultcode=(\d+)', url)
        return match.group(1) if match else None
    
    if "URL" in df.columns:
        df["EVENT_ID"] = df["URL"].apply(extract_event_id)
    else:
        df["EVENT_ID"] = None
        
    # DISTRICT 결측치 및 공백 제거
    if "DISTRICT" in df.columns:
        null_cnt = df["DISTRICT"].isna().sum()
        blank_cnt = (df["DISTRICT"].astype(str).str.strip() == "").sum()
        total_drop = null_cnt + blank_cnt
        
        if total_drop > 0:
            print(f"DISTRICT 결측 및 공백 {total_drop}행 제거됨")
            df = df[df["DISTRICT"].notna() & (df["DISTRICT"].astype(str).str.strip() != "")]
            
    # 중복 제거
    if "TITLE" in df.columns and "START_DATE" in df.columns:
        df.drop_duplicates(subset=["TITLE", "START_DATE"], inplace=True)
        
    # date 포맷 통일
    for col in ["START_DATE", "END_DATE"]:
        if col in df.columns:
            df[col] = pd.to_datetime(df[col], errors="coerce")
            df[col] = df[col].dt.date
            
    if "EVENT_ID" in df.columns:
        cols = ["EVENT_ID"] + [c for c in df.columns if c != "EVENT_ID"]
        df = df[cols]
    
    print(f"전처리 후 데이터 갯수: {len(df)}")
    return df


# ==================================================
# CSV 파일 저장
# ==================================================

# 오늘 날짜 기반 폴더 생성 (API 제공 데이터 매일 1회 업데이트)
def mkdir_today(base_dir: str = "../data") -> str:
    today = datetime.datetime.now().strftime("%Y%m%d")
    save_dir = os.path.join(base_dir, f"data_{today}")
    os.makedirs(save_dir, exist_ok=True)
    return save_dir

# 원본 데이터 저장
def save_raw_data(df: pd.DataFrame, save_dir: str) -> str:
    file_path = os.path.join(save_dir, "raw_seoul_culture_events.csv")
    df.to_csv(file_path, index=False, encoding="utf-8-sig")
    print(f"원본 데이터 저장 완료")
    return file_path

# 정제 데이터 저장
def save_cleaned_data(df: pd.DataFrame, save_dir: str) -> str:
    file_path = os.path.join(save_dir, "clean_seoul_culture_events.csv")
    df.to_csv(file_path, index=False, encoding="utf-8-sig")
    print(f"정제 데이터 저장 완료")
    return file_path


# ==================================================
# 실행
# ==================================================

def run_etl():
    print("서울시 문화행사 ETL 파이프라인")
    API_KEY = os.getenv("API_KEY")
    
    save_dir = mkdir_today()
    
    df_raw = extract_all_culture_events(API_KEY)
    if df_raw.empty:
        print("데이터 수집 실패")
        return
    raw_path = save_raw_data(df_raw, save_dir)
    
    df_clean = clean_culture_event_data(df_raw)
    clean_path = save_cleaned_data(df_clean, save_dir)
    
    print("\n=====파일 경로=====")
    print(f"원본 데이터: {raw_path}")
    print(f"정제 데이터: {clean_path}")
    
    
if __name__ == "__main__":
    run_etl()
