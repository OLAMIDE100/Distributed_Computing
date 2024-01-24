
include secret.env

run: casandra_web
	echo "successfullly startup all container"

airflow: read_env
	cd a* ; docker compose up --build -d

kafka: airflow
	cd k*  ; docker compose up -d

casandra: kafka
	cd c* ; docker compose up -d

spark: casandra
	cd s* ; docker compose up -d
	

casandra_web: spark
	cd c* ; export CASSANDRA_HOST_IP=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' cassandra) ; docker-compose --profile web up -d 


read_env: 
	 export $(shell cat  secret.env)
