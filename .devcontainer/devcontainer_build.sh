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

DOCKERIMAGE=nrf-devcontainer:${NRF_TOOLCHAIN_VERSION}
devcontainer build --workspace-folder . --image-name "$DOCKERIMAGE"
check_image "$DOCKERIMAGE"
