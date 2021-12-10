#!/bin/bash

set -euo pipefail

FOLDER="builder"

pushd "${FOLDER}" >/dev/null
  ./build.sh
popd >/dev/null
