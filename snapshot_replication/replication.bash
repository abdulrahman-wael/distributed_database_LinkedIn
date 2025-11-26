docker network create repl-net
docker volume create repl-snapshot-vol
# Verify volume mount point on Linux
docker volume inspect repl-snapshot-vol --format '{{ .Mountpoint }}'
# Output: /var/lib/docker/volumes/repl-snapshot-vol/_data

# make the shared volume suitable for writing:
docker run --rm   -v repl-snapshot-vol:/data   -u 0   alpine   sh -c "chown -R 10001:0 /data && chmod -R 770 /data"
docker run --rm   -v repl-snapshot-vol:/data   alpine   ls -ld /data
docker exec ms1-dist ls -ld /var/opt/mssql/ReplData


# create containers: 
# 1. publisher
docker run -e "ACCEPT_EULA=Y" -e "MSSQL_SA_PASSWORD=I'm2tired" \
   -e "MSSQL_PID=Developer" -e "MSSQL_AGENT_ENABLED=True" \
   -p 1433:1433 --name ms1-pub --hostname ms1-pub \
   -v sqlvolume-pub:/var/opt/mssql \
   -v repl-snapshot-vol:/var/opt/mssql/ReplData \
   --network repl-net \
   -d mcr.microsoft.com/mssql/server:2022-latest

# 2. distributer
docker run -e "ACCEPT_EULA=Y" -e "MSSQL_SA_PASSWORD=I'm2tired" \
   -e "MSSQL_PID=Developer" -e "MSSQL_AGENT_ENABLED=True" \
   -p 1434:1433 --name ms1-dist --hostname ms1-dist \
   -v sqlvolume-dist:/var/opt/mssql \
   -v repl-snapshot-vol:/var/opt/mssql/ReplData \
   --network repl-net \
   -d mcr.microsoft.com/mssql/server:2022-latest
# 3. subscriber
docker run -e "ACCEPT_EULA=Y" -e "MSSQL_SA_PASSWORD=I'm2tired" \
   -e "MSSQL_PID=Developer" -e "MSSQL_AGENT_ENABLED=True" \
   -p 1435:1433 --name ms1-sub --hostname ms1-sub \
   -v sqlvolume-sub:/var/opt/mssql \
   -v repl-snapshot-vol:/var/opt/mssql/ReplData \
   --network repl-net \
   -d mcr.microsoft.com/mssql/server:2022-latest

# Check connectivity
# From Distributor to Publisher
docker exec -it ms1-dist /opt/mssql-tools18/bin/sqlcmd -S ms1-pub -U SA -P "I'm2tired" -C -Q "SELECT @@SERVERNAME;"

# From Distributor to Subscriber
docker exec -it ms1-dist /opt/mssql-tools18/bin/sqlcmd -S ms1-sub -U SA -P "I'm2tired" -C -Q "SELECT @@SERVERNAME;"


# running the replication (respictively)
sqlcmd -S localhost,1434 -U sa -P "I'm2tired" -d master -i 01_configure_distributor.sql
sqlcmd -S localhost,1433 -U sa -P "I'm2tired" -d model -i 02_configure_publication.sql
sqlcmd -S localhost,1435 -U sa -P "I'm2tired" -d master -i 03_create_subscriber_db.sql
sqlcmd -S localhost,1434 -U sa -P "I'm2tired" -d master -i 04_start.sql
sqlcmd -S localhost,1435 -U sa -P "I'm2tired" -d master -i 05_verification.sql
