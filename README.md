# Distributed Computing

- [Overview](#overview)
- [Technologies](#technologies)
- [Getting Started](#getting-started)
- [Architecture](#architecture)

- [License](#license)

## Overview

This repository contains a comprehensive data processing pipeline leveraging Kafka, Spark, Airflow, Docker, and Cassandra. The project is designed to showcase a scalable and fault-tolerant architecture for handling large volumes of data. Additionally, fake data is generated using the Faker library to simulate a real-world use case.

## Technologies

### 1. Kafka

[Kafka](https://kafka.apache.org/) is used as the messaging backbone for the project. It enables scalable and distributed data streaming between different components of the pipeline.

### 2. Spark

[Spark](https://spark.apache.org/) is employed for large-scale data processing. It utilizes the power of distributed computing to efficiently process and analyze data from Kafka topics.

### 3. Airflow

[Airflow](https://airflow.apache.org/) is utilized for orchestrating the entire data pipeline. It allows for easy scheduling, monitoring, and management of complex workflows.

### 4. Docker

[Docker](https://www.docker.com/) is employed for containerization, ensuring consistency across different environments. Each component of the pipeline is encapsulated in a Docker container, making deployment and scaling straightforward.

### 5. Cassandra

[Cassandra](https://cassandra.apache.org/) is chosen as the NoSQL database for storing processed data. It provides scalability and high availability, making it suitable for handling large amounts of data.

### 6. Faker

[Faker](https://faker.readthedocs.io/en/master/) is used to generate synthetic data for testing and development purposes. It helps in simulating realistic data scenarios within the pipeline.

## Getting Started

To get started with the project, follow these steps:


1. **Set the environment variables in secrets.env**
```

# Airflow configurations
AIRFLOW__CORE__FERNET_KEY=
AIRFLOW__WEBSERVER__SECRET_KEY=
_AIRFLOW_WWW_USER_USERNAME=
_AIRFLOW_WWW_USER_PASSWORD=
AIRFLOW_UID=

# Postgres configurations
POSTGRES_USER=
POSTGRES_PASSWORD=
POSTGRES_DB=
# casandra configurations
MAX_HEAP_SIZE=
HEAP_NEWSIZE=
CASSANDRA_USERNAME=
CASSANDRA_PASSWORD=
CASSANDRA_PORT=



# Zookeeper configurations
ZOOKEEPER_CLIENT_PORT=
ZOOKEEPER_SERVER_ID=



# Kafka base configurations
REPLICATION_FACTOR=
CONNECT_REST_PORT=
CONNECT_REST_ADVERTISED_HOST_NAME=
KAFKA_AUTHORIZER_CLASS_NAME=
KAFKA_ALLOW_EVERYONE_IF_NO_ACL_FOUND=
SCHEMA_REGISTRY_HOST_NAME=
KAFKA_CLUSTERS_0_NAME=
DYNAMIC_CONFIG_ENABLED=




# Spark configurations
SPARK_UI_PORT=
SPARK_MASTER_PORT=
SPARK_USER=
SPARK_WORKER_MEMORY=
SPARK_WORKER_CORES=



```
2. **Run Makefile**

```
make run

```
3. **Cassandra Table Creation**
```
docker exec -it cassandra

```
```
cqlsh -u cassandra -p cassandra
CREATE KEYSPACE spark_streaming WITH replication = {'class':'SimpleStrategy','replication_factor':1};

CREATE TABLE spark_streaming.sentimental_analysis(id int primary key, sentence text, sentimental_analysis text);

```

4. **Kafka Topic Creation**
```
docker exec -it  kafka_ui

```
```
bin/kafka-topics.sh --bootstrap-server localhost:9092 --create \
                    --topic sentences \
                    --partitions 2 \
                    --replication-factor 2 \
                    --config max.message.bytes=64000 \
                    --config flush.messages=1
                    --config acks=all
                    --config min.insync.replicas=2

```


5. **Run Spark Streaming**
```
docker exec -it spark-worker 
spark-submit  --jars /opt/bitnami/spark/jars/spark-sql-kafka-0-10_2.12-3.3.0.jar,/opt/bitnami/spark/jars/spark-cassandra-connector_2.12-3.3.0.jar data/spark_streaming.py
```


## License

This project is licensed under the [MIT License](LICENSE).