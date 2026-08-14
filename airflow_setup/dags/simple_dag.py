from airflow import DAG 
from airflow.operators.python import PythonOperator 
from datetime import datetime
def fetch_data():
  print("Fetching data...")
def process_data():
  print("Processing data...")
def store_data():
  print("Storing data...")
with DAG(
  dag_id="simple_etl_dag",
  start_date=datetime(2023, 1, 1),
  schedule_interval=None,
  catchup=False,
  description="A simple ETL pipeline in Airflow",
  ) as dag:
      fetch = PythonOperator(
      task_id="fetch_data",
      python_callable=fetch_data
      )
      process = PythonOperator(
      task_id="process_data",
      python_callable=process_data
      )
      store = PythonOperator(
      task_id="store_data",
      python_callable=store_data
      )
      fetch >> process >> store