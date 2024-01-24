
run: casandra_web
	echo "successfullly startup all container"

airflow: 
	cd a* ; docker compose --env-file ../.env up --build -d

kafka: airflow
	cd k*  ; docker compose --env-file ../.env up -d

casandra: kafka
	cd c* ; docker compose --env-file ../.env up -d

spark: casandra
	cd s* ; docker compose  --env-file ../.env up -d
	

casandra_web: spark
	cd c* ; export CASSANDRA_HOST_IP=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' cassandra) ; docker-compose --env-file ../.env --profile web up -d 


