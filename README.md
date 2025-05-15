# nrf-devcontainer

Template repository to get started with nRF and Zephyr applications using a `devcontainer`.
Flashing and debugging is supported via USB passthrough.

The image is around 14GB

---

## Installed toolchain

- `nrfutil`
- `west` as an alias using the version provided by the `nrf toolchain`
- `JLink`

### Commands

To launch a shell run:

- `nrfutil sdk-manager toolchain launch --ncs-version ${NRF_TOOLCHAIN_VERSION} --shell`

To run arbitary commands run:

- `nrfutil sdk-manager toolchain launch --ncs-version ${NRF_TOOLCHAIN_VERSION} -- which python`

### How to use the template

- Clone the repo
  - Remove the `.decontainer/ci.sh` and all the files refered in it if you don't want to use them.
- Download `JLink_Linux_V832_x86_64.deb` from the `Segger website` and place it in the `.devcontainer`
 directoy.
  - You can try this (might not work if the logic on the website changed):
        ```bash
        curl -d "accept_license_agreement=accepted&submit=Download+software" \
        -X POST \
        -o .devcontainer/JLink_Linux_V832_x86_64f.deb \
        "https://www.segger.com/downloads/jlink/JLink_Linux_V832_x86_64.deb"
        ```
- Open the devcontainer in `VScode`

Then run this commands for a quick test:

- Run: `./build_test.sh`
- Run: `west build blinky --board nrf52840dk/nrf52840 --build-dir blinky/build --pristine`

---
