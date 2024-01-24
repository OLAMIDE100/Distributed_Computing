FROM --platform=linux/amd64 apache/airflow:2.5.3-python3.8



COPY ./requirements.txt  /opt/airflow/requirements.txt

RUN pip install -r /opt/airflow/requirements.txt