from src.common.redshift_client import RedShiftClient
from src.common.query_loader import load_query

client = RedShiftClient()
conn = client.connect()
cur = conn.cursor()
sql = load_query("fact_table/insert_fact_table.sql")
cur.execute(sql)