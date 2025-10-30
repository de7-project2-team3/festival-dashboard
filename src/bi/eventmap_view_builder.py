from src.common.redshift_client import RedShiftClient
from src.common.query_loader import load_query

def create_view():
    client = RedShiftClient()
    conn = client.connect()
    conn.autocommit = True
    cur = conn.cursor()
    
    try:
        query = load_query("bi/eventmap_view.sql")
        cur.execute(query)
        print("View(category_view) created successfully!")
    except Exception as e:
        print("Error while creating view: ", e)
    finally:
        cur.close()
        conn.close()

if __name__ == "__main__":
    create_view()