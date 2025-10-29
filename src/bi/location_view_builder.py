from src.common.redshift_client import RedShiftClient
from src.common.query_loader import load_query

client = RedShiftClient()
conn = client.connect()
cur = conn.cursor()
conn.autocommit = True   # conn.autocommit True로 설정
sql = load_query("bi/location_bi.sql")
cur.execute(sql)




# sql = load_query("adhoc/test.sql")
# sql = "select * from public.location_view limit 10;"
# sql = "SELECT f.event_id,f.event_name,dc.category,dp.pay_type FROM public.fact_event f LEFT JOIN public.dim_category dc ON f.category_key = dc.category_key LEFT JOIN public.dim_payment dp ON f.payment_key = dp.payment_key"
# sql = "create table public.test ( id INT PRIMARY KEY)"
# cur.execute("SELECT tablename, COUNT(*) AS cnt FROM pg_tables WHERE schemaname = current_schema() GROUP BY tablename HAVING COUNT(*) > 0;")
# cur.execute("SELECT grantee,privilege_type FROM information_schema.schema_privileges WHERE grantee = 'dongyoung' AND schema_name = 'public';")
# cur.execute("SELECT tablename FROM pg_table_def WHERE schemaname = 'public';")
# cur.execute(sql)
# print(cur.fetchall())
# tables = [row[0] for row in cur.fetchall()]
# print(tables)