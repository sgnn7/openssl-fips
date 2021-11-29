#!/bin/bash

set -euo pipefail

docker_cmd=("sudo" "docker")
if docker ps &>/dev/null; then
  docker_cmd=("docker")
fi

echo "Building FIPS HAProxy container..."

"${docker_cmd[@]}" build -t fips-haproxy .

echo "Building FIPS HAProxy container: OK"
