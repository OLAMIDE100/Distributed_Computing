# Distributed Computing


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