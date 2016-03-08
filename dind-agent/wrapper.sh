#!/bin/bash
set -e

# If the first argument to this script is "--storage-driver=foo", then set
# the variable $DOCKER_STORAGE_DRIVER to the passed in argument. Otherwise,
# default to the "overlay" storage driver.
if [[ "$1" =~ "--storage-driver" ]]; then
    DOCKER_STORAGE_DRIVER="${1#*=}"
    shift
else
    DOCKER_STORAGE_DRIVER="overlay"
fi

echo "==> Launching the Docker daemon with storage driver '${DOCKER_STORAGE_DRIVER}' ..."
dind docker daemon --host=unix:///var/run/docker.sock --storage-driver=${DOCKER_STORAGE_DRIVER} &

while(! docker info > /dev/null 2>&1); do
    echo "==> Waiting for the Docker daemon to come online..."
    sleep 1
done
echo "==> Docker Daemon is up and running!"

/bin/sh -c "$@"
