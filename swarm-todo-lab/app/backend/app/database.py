from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, declarative_base
import os
import os

import os

def get_db_url():
    with open(os.getenv("POSTGRES_PASSWORD_FILE")) as f:
        password = f.read().strip()
    user = os.getenv("POSTGRES_USER")
    dbname = os.getenv("POSTGRES_DB")
    host = os.getenv("POSTGRES_HOST")
    return f"postgresql://{user}:{password}@{host}:5432/{dbname}"

DB_URL = get_db_url()



engine = create_engine(DB_URL, pool_pre_ping=True)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
Base = declarative_base()
