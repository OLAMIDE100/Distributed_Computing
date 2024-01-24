cqlsh -u cassandra -p cassandra
CREATE KEYSPACE spark_streaming WITH replication = {'class':'SimpleStrategy','replication_factor':1};

CREATE TABLE spark_streaming.sentimental_analysis(id int primary key, sentence text, sentimental_analysis text);


CREATE TABLE spark_streaming.sentimental_analysis(id int primary key, sentence text);



cd a*
docker compose up --build -d
cd ..
cd k*   
docker compose up -d
cd ..
cd c*
docker compose up -d
cd ..
cd s*
docker compose up -d


docker exec -it spark-worker spark-submit  --jars /opt/bitnami/spark/jars/spark-sql-kafka-0-10_2.12-3.3.0.jar,/opt/bitnami/spark/jars/spark-cassandra-connector_2.12-3.3.0.jar data/spark_streaming.py
cd ..
cd c*
export CASSANDRA_HOST_IP=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' cassandra)
docker-compose --profile web up -d 
