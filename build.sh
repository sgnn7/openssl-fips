#!/bin/bash

set -euo pipefail

echo "Building..."

./build_fips_builder.sh
./build_fips_canister.sh
./build_fips_openssl.sh

if [ ! -z "${1:-}" ]; then
  tool_name="$1"
  echo
  echo "Requested building of ${tool_name}..."

  cd "derived-tools/$1"
  ./build.sh
fi

echo "Build completed!"
