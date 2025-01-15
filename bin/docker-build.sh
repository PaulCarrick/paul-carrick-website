# !/bin/sh
set -a
. .env
set +a

echo "Building Docker Container"
docker build --progress=plain ${NO_CACHE} \
  --build-arg SUDO_AVAILABLE=${SUDO_AVAILABLE} \
  --build-arg SUDO_USER_PASSWORD=${SUDO_USER_PASSWORD} \
  --build-arg DB_PASSWORD=${DB_PASSWORD} \
  --build-arg INTERNAL_PORT=${INTERNAL_PORT} \
  --build-arg EXTERNAL_PORT=${EXTERNAL_PORT} \
  --build-arg SSH_PORT=${SSH_PORT} \
  .
if [ $? -eq 0 ]; then
  echo "The build succeeded."
else
  echo "The build failed with exit status $?."
fi
