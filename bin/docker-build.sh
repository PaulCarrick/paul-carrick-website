# !/bin/sh
set -a
. secrets/.env
set +a

echo "Building Docker Container"

docker build --file Dockerfile-paul ${@} .

if [ $? -eq 0 ]; then
  echo "The build succeeded."
else
  echo "The build failed with exit status $?."
fi
