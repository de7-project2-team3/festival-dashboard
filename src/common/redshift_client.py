import psycopg2
from dotenv import load_dotenv
import os

load_dotenv()

class RedShiftClient:
    def __init__(self):
        self.host = os.getenv("REDSHIFT_HOST")
        self.port = int(os.getenv("REDSHIFT_PORT", 5439))
        self.db = os.getenv("REDSHIFT_DB")
        self.user = os.getenv("REDSHIFT_USER")
        self.pw = os.getenv("REDSHIFT_PASSWORD")

    def connect(self):
        try:
            return psycopg2.connect(
                host=self.host,
                port=self.port,
                dbname=self.db,
                user=self.user,
                password=self.pw,
                connect_timeout=5
            )
        except Exception as e:
            print("Connection error:", e)
            raise
