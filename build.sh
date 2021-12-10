#!/bin/bash

set -euo pipefail

echo "Building..."

BUILD_ORDER=( "builder"
              "canister"
              "openssl" )

for step in "${BUILD_ORDER[@]}"; do
  "./build_fips_${step}.sh"
done

if [ -n "${1:-}" ]; then
  tool_name="$1"
  echo
  echo "Requested building of ${tool_name}..."

  pushd "derived-tools/$1" >/dev/null
    ./build.sh
  popd
fi

echo "Build completed!"
