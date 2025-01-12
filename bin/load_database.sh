# \!/bin/sh

INCLUDE_STORAGE_FLAG=false
NO_COPY_FLAG=false

for arg in "$@"; do
  if [ "$arg" = "INCLUDE_STORAGE" ]; then
    INCLUDE_STORAGE_FLAG=true
  fi

  if [ "$arg" = "NO_COPY" ]; then
    NO_COPY_FLAG=true
  fi
done

DATE_STRING=`date +"%m-%d-%Y"`
USER="paul"
DATABASE="paul-carrick"
DUMP_NAME="${DATABASE}_database_${DATE_STRING}.dump"
REMOTE_DUMP_NAME="paul@paul-carrick.com:${DUMP_NAME}"
LOCAL_DUMP_NAME="${DATABASE}_local_database_${DATE_STRING}.dump"
REMOTE_STORAGE_NAME="paul@paul-carrick.com:${DATABASE}_images_${DATE_STRING}.tar.gz"
LOCAL_STORAGE_NAME="${DATABASE}_images_${DATE_STRING}.tar.gz"

if [ "$NO_COPY_FLAG" = "false" ]; then
    scp "${REMOTE_DUMP_NAME}" "${HOME}"

    if [ $? -ne 0 ]; then
      echo "Error: Failed to copy ${REMOTE_DUMP_NAME} to ${HOME}"
      exit 1
    fi

    if [ "$INCLUDE_STORAGE_FLAG" = "true" ]; then
        scp "${REMOTE_STORAGE_NAME}" "${HOME}"

        if [ $? -ne 0 ]; then
          echo "Error: Failed to copy ${REMOTE_STORAGE_NAME} to ${HOME}"
          exit 1
        fi
    fi
fi

pg_dump -U "${USER}" -d "${DATABASE}" -F c -f "${HOME}/${LOCAL_DUMP_NAME}"

if [ $? -ne 0 ]; then
  echo "Error: Failed to backup ${HOME}/${LOCAL_DUMP_NAME}"
  exit 1
fi

psql -U "${USER}" -d postgres -c "SELECT pg_terminate_backend(pg_stat_activity.pid) FROM pg_stat_activity WHERE pg_stat_activity.datname = '${DATABASE}' AND pid <> pg_backend_pid();"

dropdb -U "${USER}" "${DATABASE}"

if [ $? -ne 0 ]; then
  echo "Error: Failed to drop ${DATABASE}"
  exit 1
fi

createdb -U "${USER}" "${DATABASE}"

if [ $? -ne 0 ]; then
  echo "Error: Failed to drop ${DATABASE}"
  exit 1
fi

pg_restore -U "${USER}" -d  "${DATABASE}" "${HOME}/${DUMP_NAME}"

if [ $? -ne 0 ]; then
  echo "Error: Failed to restore ${HOME}/${LOCAL_DUMP_NAME}"
  exit 1
fi

if [ "$INCLUDE_STORAGE_FLAG" = "true" ]; then
    rm -rf storage

    if [ $? -ne 0 ]; then
      echo "Error: Failed to delete storage"
      exit 1
    fi

    tar -xzvf "${HOME}/${LOCAL_STORAGE_NAME}"

    if [ $? -ne 0 ]; then
      echo "Error: Failed to restore ${HOME}/${LOCAL_STORAGE_NAME}"
      exit 1
    fi
fi

echo "${DATABASE} restored successfully."
exit 0;
