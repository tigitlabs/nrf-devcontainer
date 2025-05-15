FROM mcr.microsoft.com/devcontainers/base:ubuntu-24.04

ARG NRF_TOOLCHAIN_VERSION="v3.0.1"
ENV NRF_TOOLCHAIN_VERSION=${NRF_TOOLCHAIN_VERSION}

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
    libxcb-render0 \
    libxcb-render-util0 \
    libxcb-shape0 \
    libxcb-icccm4 \
    libxcb-keysyms1 \
    libxcb-image0 \
    libxkbcommon-x11-0 \
    && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/*

WORKDIR /tmp
COPY JLink_Linux_V832_x86_64.deb /tmp/JLink_Linux_V832_x86_64.deb
RUN dpkg --unpack JLink_Linux_V832_x86_64.deb && \
    rm -f /var/lib/dpkg/info/jlink.postinst && \
    dpkg --configure jlink

# pipx install west
# Add pipx to PATH
# ENV PATH="${PATH}:/home/vscode/.local/bin/"

WORKDIR /workspaces
RUN chown -R vscode:vscode /workspaces
RUN curl https://files.nordicsemi.com/artifactory/swtools/external/nrfutil/executables/x86_64-unknown-linux-gnu/nrfutil -o nrfutil && \
    chmod +x nrfutil && \
    mv nrfutil /usr/local/bin

USER vscode
RUN nrfutil install completion device sdk-manager
RUN nrfutil sdk-manager install ${NRF_TOOLCHAIN_VERSION}

ENV ZEPHYR_BASE="/home/vscode/ncs/${NRF_TOOLCHAIN_VERSION}/zephyr/"

RUN echo '[[ -r "${HOME}/.nrfutil/share/nrfutil-completion/scripts/bash/setup.bash" ]] && . "${HOME}/.nrfutil/share/nrfutil-completion/scripts/bash/setup.bash"' >> ~/.bashrc && \
    echo 'alias west="nrfutil sdk-manager toolchain launch --ncs-version ${NRF_TOOLCHAIN_VERSION} -- west"' >> ~/.bashrc

WORKDIR /workspaces/nrf-devcontainer
