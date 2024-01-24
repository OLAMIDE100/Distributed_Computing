from datetime import timedelta
from airflow import DAG
from airflow.operators.python_operator import PythonOperator
from airflow.operators.dummy_operator import DummyOperator
from datetime import datetime
from stream_to_kafka import start_streaming

start_date = datetime(2023, 12, 29)

default_args = {
    'owner': 'airflow',
    'start_date': start_date,
    'retries': 1,
    'retry_delay': timedelta(seconds=5),
    "sla": timedelta(hours=2)
}



with DAG('sentence_generator', 
         default_args=default_args, 
         schedule_interval='*/10 * * * *', 
         catchup=False) as dag:

    start = DummyOperator(task_id='start')


    data_stream_task = PythonOperator(
    task_id='kafka_data_stream',
    python_callable=start_streaming,
    dag=dag,
    )

    
    end = DummyOperator(task_id='end')

    start >> data_stream_task >> end