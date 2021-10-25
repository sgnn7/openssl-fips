#!/bin/bash

set -euo pipefail

echo "Building..."

./build_fips_canister.sh
./build_fips_openssl.sh

echo "Build completed!"
