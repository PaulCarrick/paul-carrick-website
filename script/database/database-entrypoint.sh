#!/bin/sh
# setup-database.sh

set -a
  . /postgres/script/.env
set +a

if [ -n "$SSH_PORT" ]; then sudo service ssh start; fi

pg_createcluster 15 main
service postgresql start

su - postgres -c "psql -h ${DB_HOST} -U ${POSTGRES_USER} -c \"ALTER ROLE postgres WITH PASSWORD '${POSTGRES_PASSWORD}';\""
python /postgres/script/setup-database.py -R false -i true -v 4

while true; do # Sleep for debugging and access without server running
  sleep 300
done
