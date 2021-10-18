#!/bin/bash

set -euo pipefail

echo "Building the canister..."
sudo docker build -t fips-canister -f Dockerfile.canister .
echo "Building the canister: OK"
