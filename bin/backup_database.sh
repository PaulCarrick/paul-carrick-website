# \!/bin/sh

INCLUDE_STORAGE_FLAG=false

for arg in "$@"; do
  if [ "$arg" = "INCLUDE_STORAGE" ]; then
    INCLUDE_STORAGE_FLAG=true
    break
  fi
done

DATE_STRING=`date +"%m-%d-%Y"`
USER="paul"
DATABASE="paul-carrick"
LOCAL_DUMP_NAME="${DATABASE}_database_${DATE_STRING}.dump"
LOCAL_STORAGE_NAME="${DATABASE}_images_${DATE_STRING}.tar.gz"

pg_dump -U "${USER}" -d "${DATABASE}" -F c -f "${HOME}/${LOCAL_DUMP_NAME}"

if [ $? -ne 0 ]; then
  echo "Error: Failed to backup ${HOME}/${LOCAL_DUMP_NAME}"
  exit 1
fi

if [ "$INCLUDE_STORAGE_FLAG" = "true" ]; then
    tar -czvf "${HOME}/${LOCAL_STORAGE_NAME}" storage/

    if [ $? -ne 0 ]; then
      echo "Error: Failed to copy ${REMOTE_STORAGE_NAME} to ${HOME}"
      exit 1
    fi
fi

echo "${DATABASE} backed up successfully."
exit 0;
