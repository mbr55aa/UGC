build:
	docker network create movies_network || true
	docker-compose up -d --build
	docker-compose -f ./elk/docker-compose.yml up -d --build

up:
	docker network create movies_network || true
	docker-compose up -d
	docker-compose -f ./elk/docker-compose.yml up -d

down:
	docker-compose down --remove-orphans
	docker-compose -f ./elk/docker-compose.yml down --remove-orphans
	docker network rm movies_network

stop:
	docker-compose stop
	docker-compose -f ./elk/docker-compose.yml stop

db:
	docker exec -it clickhouse-node1 bash -c 'printf "CREATE DATABASE shard;" | clickhouse-client'
	docker exec -it clickhouse-node1 bash -c 'printf "CREATE DATABASE replica;" | clickhouse-client'
	docker exec -it clickhouse-node1 bash -c 'printf "CREATE TABLE shard.film_view (id UUID, user UUID, film UUID, progress_time Int64) Engine=ReplicatedMergeTree(\x27/clickhouse/tables/shard1/film_view\x27, \x27replica_1\x27) PARTITION BY film ORDER BY id;" | clickhouse-client'
	docker exec -it clickhouse-node1 bash -c 'printf "CREATE TABLE replica.film_view (id UUID, user UUID, film UUID, progress_time Int64) Engine=ReplicatedMergeTree(\x27/clickhouse/tables/shard2/film_view\x27, \x27replica_2\x27) PARTITION BY film ORDER BY id;" | clickhouse-client'
	docker exec -it clickhouse-node1 bash -c 'printf "CREATE TABLE default.film_view (id UUID, user UUID, film UUID, progress_time Int64) ENGINE = Distributed(\x27company_cluster\x27, \x27\x27, film_view, rand());" | clickhouse-client'
	docker exec -it clickhouse-node3 bash -c 'printf "CREATE DATABASE shard;" | clickhouse-client'
	docker exec -it clickhouse-node3 bash -c 'printf "CREATE DATABASE replica;" | clickhouse-client'
	docker exec -it clickhouse-node3 bash -c 'printf "CREATE TABLE shard.film_view (id UUID, user UUID, film UUID, progress_time Int64) Engine=ReplicatedMergeTree(\x27/clickhouse/tables/shard2/film_view\x27, \x27replica_1\x27) PARTITION BY film ORDER BY id;" | clickhouse-client'
	docker exec -it clickhouse-node3 bash -c 'printf "CREATE TABLE replica.film_view (id UUID, user UUID, film UUID, progress_time Int64) Engine=ReplicatedMergeTree(\x27/clickhouse/tables/shard1/film_view\x27, \x27replica_2\x27) PARTITION BY film ORDER BY id;" | clickhouse-client'
	docker exec -it clickhouse-node3 bash -c 'printf "CREATE TABLE default.film_view (id UUID, user UUID, film UUID, progress_time Int64) ENGINE = Distributed(\x27company_cluster\x27, \x27\x27, film_view, rand());" | clickhouse-client'
