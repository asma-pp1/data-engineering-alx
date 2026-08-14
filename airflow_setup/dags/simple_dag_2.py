from airflow import DAG 
from airflow.operators.python import PythonOperator 
from datetime import datetime
def fetch_data():
  print("Fetching data...")
def process_data():
  print("Processing data...")
def store_data():
  print("Storing data...")
def validate_data():
    row_count = 5   # set to 0 to see the failure path
    if row_count == 0:
        raise ValueError("No data fetched")
    print("Validation passed")
with DAG(
  dag_id="simple_etl_dag_2",
  start_date=datetime(2023, 1, 1),
  schedule_interval=None,
  catchup=False,
  description="A simple ETL pipeline in Airflow",
  ) as dag:
      fetch = PythonOperator(
      task_id="fetch_data",
      python_callable=fetch_data
      )
      validate = PythonOperator(
      task_id="validate_data",
      python_callable=validate_data
      )
      process = PythonOperator(
      task_id="process_data",
      python_callable=process_data
      )
      store = PythonOperator(
      task_id="store_data",
      python_callable=store_data
      )
      fetch >> validate >> process >> store