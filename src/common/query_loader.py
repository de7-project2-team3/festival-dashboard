from pathlib import Path

def load_query(relative_path: str) -> str:
    root = Path(__file__).resolve().parents[2]  # project root
    query_path = root / "queries" / relative_path
    return query_path.read_text(encoding="utf-8")
