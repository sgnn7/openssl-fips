#!/bin/bash

set -euo pipefail

# Disable annoying messages from docker
export DOCKER_SCAN_SUGGEST=false

docker_cmd=("sudo" "docker")
if docker ps &>/dev/null; then
  docker_cmd=("docker")
fi

container_name_suffix="linux"
if [[ $(docker info --format '{{json .}}' | jq -r .Driver) == "windowsfilter" ]]; then
  echo "WARN: Windows build detected!"
  container_name_suffix="windows"
fi

# Check that we have the canister image available
if ! docker image inspect "fips-canister-${container_name_suffix}" &>/dev/null; then
  echo "WARN: Canister image not found! Building..."
  pushd .. >/dev/null
    ./build_fips_canister.sh "$@"
  popd >/dev/null
fi

echo "Building the OpenSSL container..."

"${docker_cmd[@]}" build \
  -t "fips-openssl-${container_name_suffix}" \
  -f "Dockerfile.${container_name_suffix}" \
  .

echo "Building the OpenSSL container: OK"
