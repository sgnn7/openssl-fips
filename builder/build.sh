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

echo "Building the builder tooling container..."

"${docker_cmd[@]}" build \
  -t "fips-builder-${container_name_suffix}" \
  -f "Dockerfile.${container_name_suffix}" \
  .

echo "Building the builder tooling container: OK"
