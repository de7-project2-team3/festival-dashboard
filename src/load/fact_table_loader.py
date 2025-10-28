from src.common.redshift_client import RedShiftClient

client = RedShiftClient()
conn = client.connect()
cur = conn.cursor()
cur.execute("SELECT current_user, current_database();")
print(cur.fetchall())