#!/bin/bash
NRF_TOOLCHAIN_VERSION=v3.0.1
set -euo pipefail

echo "👟 docker_build_ci.sh"
.devcontainer/docker_build_ci.sh
echo "👟 docker_build_dev.sh"
.devcontainer/docker_build_dev.sh
echo "👟 docker_build.sh"
.devcontainer/devcontainer_build.sh
