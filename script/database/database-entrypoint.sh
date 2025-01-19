#!/bin/sh
# setup-database.sh

set -a
  . ./.env
set +a

if [ -n "$SSH_PORT" ]; then sudo service ssh start; fi

main=""

clusters=`/usr/bin/pg_lsclusters` && \
main=`echo ${clusters} | grep -q "main"`

if [ -n main ]; then
  service postgresql start
else
  pg_createcluster 15 main
  service postgresql start
fi

su - postgres -c "psql -U postgres -c \"ALTER ROLE postgres WITH PASSWORD '${POSTGRES_PASSWORD}';\""
python ./setup-database.py -R false -i true -v 4

while true; do # Sleep for debugging and access without server running
  sleep 300
done
