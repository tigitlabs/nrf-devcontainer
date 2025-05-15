#!/bin/bash
# Script to test the devcontainer setup
# Currently there are 2 Dockerfiles maintained
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

# CI Container
DOCKERIMAGE=nrf-ci:${NRF_TOOLCHAIN_VERSION}
DOCKERFILE=DockerfileCI
docker build --tag $DOCKERIMAGE --file $DOCKERFILE .
echo "Built $DOCKERIMAGE"
check_image "$DOCKERIMAGE"
# Smoketest
docker run --rm $DOCKERIMAGE bash -c "cd /workspaces/ncs/ && west build -b reel_board ${NRF_TOOLCHAIN_VERSION}/zephyr/samples/basic/blinky"
echo "sudo docker run -t -i --privileged -v /dev/bus/usb/:/dev/bus/usb $DOCKERIMAGE bash"

cd ..
