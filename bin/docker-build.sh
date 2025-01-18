#!/bin/sh

set -e

# Get the container type from the first argument
container=$1
clean=$2

echo "Building Docker Container"

if [ "${clean}" = "true" ]; then
    docker system prune --all -f --volumes
    launchctl stop com.docker.docker
    launchctl start com.docker
fi

if [ "${container}" = "db" ]; then
    if [ -f ./initdb.d/env ]; then rm -rf ./initdb.d ;  fi
    if [ -f ./initrails.d/env ]; then rm -rf ./initrails.d ; fi

    # Copy and set environment variables
    cp -R ./build/initdb.d ./initdb.d

    set -a
        . ./initdb.d/env
    set +a

    # Build and bring up the db container
    docker build  --no-cache -f build/Dockerfile-DB --progress=plain -t db .
    docker compose -f build/docker-compose-db.yml --env-file initdb.d/env up

    if [ -f ./initdb.d/env ]; then rm -rf ./initdb.d ;  fi
else
    if [ -f ./initrails.d/env ]; then rm -rf ./initrails.d ; fi
    if [ -f ./initdb.d/env ]; then rm -rf ./initdb.d ;  fi

    # Copy and set environment variables
    cp -R ./build/initrails.d ./initrails.d

    set -a
        . ./initrails.d/env
    set +a

    # Build and bring up the Rails container
    docker build  --no-cache -f build/Dockerfile-Rails --progress=plain -t rails .
    docker compose -f build/docker-compose-rails.yml --env-file initrails.d/env up

    # Clean up
    if [ -f ./initrails.d/env ]; then
        rm -rf ./initrails.d
    fi
fi

echo "Docker Container Built"
