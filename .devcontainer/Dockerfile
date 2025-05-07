FROM mcr.microsoft.com/devcontainers/base:ubuntu-24.04

ARG NRF_TOOLCHAIN_VERSION="v3.0.0"


RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
    bash-completion \
    python3 \
    python3-dev \
    python3-pip \
    python3-setuptools \
    python3-tk \
    python3-wheel \
    cmake \
    ninja-build \
    gperf \
    ccache \
    dfu-util \
    device-tree-compiler \
    xz-utils file \
    make \
    gcc \
    gcc-multilib \
    g++-multilib \
    libsdl2-dev \
    libmagic1 \
    pipx \
    # Clean up
    && apt-get autoremove -y && apt-get clean -y

USER vscode
WORKDIR /workspaces
RUN pipx install west
# Add pipx to PATH
ENV PATH="${PATH}:/home/vscode/.local/bin/"

# Install nrfutil and toolchain
RUN curl https://files.nordicsemi.com/artifactory/swtools/external/nrfutil/executables/x86_64-unknown-linux-gnu/nrfutil -o nrfutil && \
    sudo chmod +x nrfutil && \
    sudo mv nrfutil /usr/local/bin && \
    nrfutil install completion device sdk-manager
RUN nrfutil sdk-manager install ${NRF_TOOLCHAIN_VERSION}
ENV ZEPHYR_BASE="/home/vscode/ncs/${NRF_TOOLCHAIN_VERSION}/zephyr/"
RUN west update && west packages pip --install
