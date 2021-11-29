#!/bin/bash

set -euo pipefail

docker_cmd=("sudo" "docker")
if docker ps &>/dev/null; then
  docker_cmd=("docker")
fi

echo "Building the OpenSSL canister container..."

"${docker_cmd[@]}" build -t fips-canister -f Dockerfile.canister .

echo "Building the OpenSSL canister container: OK"
