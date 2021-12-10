#!/bin/bash

set -euo pipefail

FOLDER="canister"

pushd "${FOLDER}" >/dev/null
  ./build.sh
popd >/dev/null
