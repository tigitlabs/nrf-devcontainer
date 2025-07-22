FROM mcr.microsoft.com/devcontainers/base:ubuntu-24.04

ARG NRF_TOOLCHAIN_VERSION="v3.0.1"
ARG INSTALL_JLINK="false"
ARG JLINK_VERSION="V832"

ENV INSTALL_JLINK=${INSTALL_JLINK}
ENV JLINK_PACKAGE_FILE="JLink_Linux_${JLINK_VERSION}_x86_64.deb"
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
    gnupg2 \
    && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/*

WORKDIR /workspaces
RUN chown -R vscode:vscode /workspaces
RUN curl https://files.nordicsemi.com/artifactory/swtools/external/nrfutil/executables/x86_64-unknown-linux-gnu/nrfutil -o nrfutil && \
    chmod +x nrfutil && \
    mv nrfutil /usr/local/bin

USER vscode
RUN pipx install pre-commit==4.2.0
# Add pipx to PATH
ENV PATH="${PATH}:/home/vscode/.local/bin/"

RUN nrfutil install completion device sdk-manager && \
    nrfutil sdk-manager install ${NRF_TOOLCHAIN_VERSION}

ENV ZEPHYR_BASE="/home/vscode/ncs/${NRF_TOOLCHAIN_VERSION}/zephyr/"

RUN echo '[[ -r "${HOME}/.nrfutil/share/nrfutil-completion/scripts/bash/setup.bash" ]] && . "${HOME}/.nrfutil/share/nrfutil-completion/scripts/bash/setup.bash"' >> ~/.bashrc && \
    echo 'alias west="nrfutil sdk-manager toolchain launch --ncs-version ${NRF_TOOLCHAIN_VERSION} -- west"' >> ~/.bashrc

USER root
WORKDIR /tmp
COPY ${JLINK_PACKAGE_FILE} /tmp/${JLINK_PACKAGE_FILE}

RUN if [ "$INSTALL_JLINK" = "true" ]; then \
        echo "Installing J-Link..."; \
        dpkg --unpack /tmp/${JLINK_PACKAGE_FILE} && \
        rm -f /var/lib/dpkg/info/jlink.postinst && \
        dpkg --configure jlink; \
    else \
        echo "Skipping J-Link install, dummy package used."; \
    fi

USER vscode
WORKDIR /workspaces
