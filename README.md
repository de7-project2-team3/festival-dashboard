### uv 사용
> 이 프로젝트는 `uv`를 사용하여 Python 가상 환경과 패키지를 관리합니다.

# How to Use (UV)

### Installation

[Installing uv](https://docs.astral.sh/uv/getting-started/installation/)

To install the UV package, you can use Homebrew.

Run the following command in your terminal:

```bash
brew install uv
```

### how to use uv

[Features](https://docs.astral.sh/uv/getting-started/features/)

- 프로젝트에 새로운 패키지를 추가할 때:
  - `uv add <package_name>`
- 패키지를 제거할 때:
  - `uv remove <package_name>`
- 설치된 패키지 확인:
  - `uv pip list`
- .venv 환경에서 명령어 실행:
  - `uv run <command>`

## 초기 세팅

```bash
make init # Python 가상환경 생성 및 패키지 설치 (uv venv && uv sync)

make superset-init	# Superset 컨테이너 실행 + 관리자 계정(username: admin, password: admin) 생성
                    # localhost:8088로 접속하셔서 로그인되는지 확인부탁드립니다.

make superset-up	# Superset 컨테이너 실행

make superset-down	# Superset 컨테이너 중지

make superset-reset	# Superset 환경 완전 초기화 (볼륨 삭제 포함)
```

### .env
계정 정보 및 기타 민감한 설정 값은 .env 파일의 환경 변수로 관리할려고 합니다.
