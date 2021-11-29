#!/bin/bash

set -euo pipefail

docker_cmd=("sudo" "docker")
if docker ps &>/dev/null; then
  docker_cmd=("docker")
fi

echo "Building the OpenSSL container..."

"${docker_cmd[@]}" build -t fips-openssl -f Dockerfile.openssl .

echo "Building the OpenSSL container: OK"
