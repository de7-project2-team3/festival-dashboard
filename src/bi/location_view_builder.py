from src.common.redshift_client import RedShiftClient
from src.common.query_loader import load_query

client = RedShiftClient()
conn = client.connect()
cur = conn.cursor()
sql = load_query("bi/location_bi.sql")
cur.execute(sql)