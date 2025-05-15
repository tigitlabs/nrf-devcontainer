#!/bin/bash
NRF_TOOLCHAIN_VERSION=v3.0.1
set -euo pipefail

function check_image() {
    local image="$1"
    if docker image list --format '{{.Repository}}:{{.Tag}}' | grep -q "^${image}$"; then
      echo "Image $image found ✅"
      docker image list --format '{{.Repository}}:{{.Tag}} Size: {{.Size}}' | grep "${image}"
    else
      echo "Error: Image $image not found ❌"
      exit 1
    fi
}

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Dev Container
DOCKERFILE=Dockerfile
DOCKERIMAGE=nrf-dev:${NRF_TOOLCHAIN_VERSION}
docker build --tag $DOCKERIMAGE --file $DOCKERFILE .
echo "Built $DOCKERIMAGE"
check_image "$DOCKERIMAGE"
echo "Run: docker run --rm -it -v "$(pwd):/workspaces/nrf-devcontainer" "$DOCKERIMAGE" bash"

cd ..

rm -rf blinky
# Test if the freestanding version also works
docker run --rm \
  -v "$(pwd):/workspaces/nrf-devcontainer" \
  $DOCKERIMAGE bash -c "\
  cd /workspaces/nrf-devcontainer &&
  ./build_test.sh"

# Check if the hex file exists
if [ -f "blinky/build/merged.hex" ]; then
  echo "✅ Hex file exists"
else
  echo "❌ Hex file does not exist"
  exit 1
fi
