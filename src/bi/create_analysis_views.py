from src.common.redshift_client import RedShiftClient
from src.common.query_loader import load_query


def create_analysis_views():
    """시기별 문화행사 패턴 분석을 위한 View들을 생성합니다."""
    
    client = RedShiftClient()
    conn = client.connect()
    cur = conn.cursor()
    conn.autocommit = True
    
    # 생성할 View 목록
    views = [
        "bi/monthly_event_trends.sql",
        "bi/seasonal_event_trends.sql",
        "bi/quarterly_category_trends.sql"
    ]
    
    success_count = 0
    fail_count = 0
    
    for view_file in views:
        try:
            sql = load_query(view_file)
            cur.execute(sql)
            print(f"✓ {view_file} 생성 완료")
            success_count += 1
        except Exception as e:
            print(f"✗ {view_file} 생성 실패: {e}")
            fail_count += 1
    
    cur.close()
    conn.close()
    
    print("="*80)
    print(f"완료: 성공 {success_count}개, 실패 {fail_count}개")
    print("="*80)
    
    if fail_count == 0:
        print("\nView가 성공적으로 생성되었습니다")
    else:
        print("\n일부 View 생성에 실패했습니다.")


if __name__ == "__main__":
    create_analysis_views()