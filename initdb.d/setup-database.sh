# !/bin/sh

# setup-database.sh
set -e

if [ -f "env" -a -f "export_env.py" ]; then eval "$(python3 export_env.py "env")" ; fi

if [ -n "$SSH_PORT" ]; then sudo service ssh start; fi

if [ "${STARTUP}" = "true" ]; then
    # Ensure required environment variables are set
    if [ -z "${POSTGRES_USER}" ] || [ -z "${DB_DATABASE}" ] || [ -z "${DB_USERNAME}" ] || [ -z "${DB_PASSWORD}" ] || [ -z "${USERNAME}" ] || [ -z "${USER_PASSWORD}" ]; then
      echo "Error: One or more required environment variables are not set."
      exit 1
    fi

    echo "Creating additional PostgreSQL tables and roles..."

    # Ensure the database exists
    psql -v ON_ERROR_STOP=1 --username "${POSTGRES_USER}" <<-EOSQL
      DO \$\$
      BEGIN
        IF NOT EXISTS (SELECT FROM pg_database WHERE datname = '${DB_DATABASE}') THEN
          CREATE DATABASE ${DB_DATABASE};
        END IF;
      END
      \$\$;

      DO \$\$
      BEGIN
        IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = '${DB_USERNAME}') THEN
          CREATE ROLE ${DB_USERNAME} WITH LOGIN PASSWORD '${DB_PASSWORD}';
        END IF;

        IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = '${USERNAME}') THEN
          CREATE ROLE ${USERNAME} WITH LOGIN PASSWORD '${USER_PASSWORD}';
        END IF;
      END
      \$\$;

      GRANT ALL PRIVILEGES ON DATABASE ${DB_DATABASE} TO ${DB_USERNAME};
      GRANT ALL PRIVILEGES ON DATABASE ${DB_DATABASE} TO ${USERNAME};
    EOSQL

    # Check if the database is empty
    echo "Checking if the database is empty..."
    IS_EMPTY=$(psql -U "$DB_USERNAME" -d "$DB_DATABASE" -tAc \
      "SELECT NOT EXISTS (SELECT 1 FROM pg_tables WHERE schemaname = 'public');")

    if [ "${IS_EMPTY}" = "t" ]; then
      if [ -f "database.dump" ]; then
        echo "Restoring database from dump..."
        pg_restore -U "${DB_USERNAME}" -d "${DB_DATABASE}" database.dump
      else
        echo "Error: database.dump file not found. Skipping restore."
      fi
    else
      echo "The database '${DB_DATABASE}' is not empty. Skipping restore."
    fi
fi
