from src.common.redshift_client import RedShiftClient
from src.common.query_loader import load_query

client = RedShiftClient()
conn = client.connect()
cur = conn.cursor()
# cur.execute("SELECT * FROM public.dim_subject limit 10")
# cur.execute("SELECT current_user;")
# cur.execute("SELECT nspname AS schema, pg_catalog.has_schema_privilege('dongyoung', nspname, 'usage') AS usage,pg_catalog.has_schema_privilege('dongyoung', nspname, 'create') AS create FROM pg_namespace ORDER BY nspname;")
# cur.execute("SELECT * FROM public.dim_location order by location_key limit 10;")
# cur.execute("SELECT * FROM public.dim_location;")
# cur.execute("SELECT table_schema,table_name,has_table_privilege(current_user, table_schema || '.' || table_name, 'select')  AS can_select,has_table_privilege(current_user, table_schema || '.' || table_name, 'insert')  AS can_insert,has_table_privilege(current_user, table_schema || '.' || table_name, 'update')  AS can_update,has_table_privilege(current_user, table_schema || '.' || table_name, 'delete')  AS can_delete,has_table_privilege('dongyoung', table_schema || '.' || table_name, 'references') AS can_references FROM information_schema.tables WHERE table_name = 'public.dim_location';")
# cur.execute("SELECT has_table_privilege(current_user, 'public.staging_events', 'select') AS can_select;")
# print(cur.fetchall())
# cur.execute("SELECT has_table_privilege(current_user, 'public.dim_date', 'select') AS can_select;")
# cur.execute("SELECT * FROM pg_table_def WHERE schemaname = 'public' AND tablename = 'fact_event';")
# cur.execute("SHOW TABLE public.fact_event;")
# cur.execute("select tablename from pg_tables where schemaname = 'public';")
# cur.execute("select * from public.staging_events limit 10")
# sql = load_query("fact_table/insert_fact_table.sql")
# cur.execute(sql)
cur.execute("select * from public.fact_event limit 10;")
print(cur.fetchall())

