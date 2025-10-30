from src.common.redshift_client import RedShiftClient
from src.common.query_loader import load_query

def create_location_view():
    client = RedShiftClient()
    conn = client.connect()
    conn.autocommit = True   # conn.autocommit True로 설정
    cur = conn.cursor()
    
    try:
        sql = load_query("bi/location_bi.sql")
        cur.execute(sql)
        print("View(location_view) created successfully!")
    except Exception as e:
        print("Error while creating View(location_view)", e)
    finally:
        cur.close()
        conn.close()

if __name__ == "__main__":
    create_location_view()
    