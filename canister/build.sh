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

# Check that we have the builder image available
if ! docker image inspect "fips-builder-${container_name_suffix}" &>/dev/null; then
  echo "WARN: Builder image not found! Building..."
  pushd .. >/dev/null
    ./build_fips_builder.sh "$@"
  popd
fi

echo "Building the OpenSSL canister container..."

"${docker_cmd[@]}" build \
  -t "fips-canister-${container_name_suffix}" \
  -f "Dockerfile.${container_name_suffix}" \
  .

echo "Building the OpenSSL canister container: OK"
