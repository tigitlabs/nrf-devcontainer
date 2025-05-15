#!/bin/bash
NRF_TOOLCHAIN_VERSION=v3.0.1
set -euo pipefail

.devcontainer/docker_build_ci.sh
.devcontainer/docker_build_dev.sh
.devcontainer/devcontainer_build.sh
