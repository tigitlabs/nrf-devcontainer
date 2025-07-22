# nrf-devcontainer

Template repository to get started with nRF and Zephyr applications using a `devcontainer`.
Flashing and debugging is supported via USB passthrough.

The image is around 14GB.<br>
⚠️ You need a machine with more than 32GB to use`Codespaces`.

---

## Installed toolchain

- `nrfutil`
  - Version can be set in the `devcontainer.json`
    `"NRF_TOOLCHAIN_VERSION": "v3.0.1"`
- `west` as an alias using the version provided by the `nrf toolchain`
- `JLink`
  - if `"INSTALL_JLINK": "true"` is set the `"JLINK_PACKAGE_FILE": "JLink_Linux_V832_x86_64.deb"`
file has to be
available during build time in the `.devcontainer` directory. If it is set to `false`
there will be dummy file created with the `initializeCommand`. Default is set to `false`.

### Commands

To launch a shell run:

- `nrfutil sdk-manager toolchain launch --ncs-version ${NRF_TOOLCHAIN_VERSION} --shell`

To run arbitary commands run:

- `nrfutil sdk-manager toolchain launch --ncs-version ${NRF_TOOLCHAIN_VERSION} -- which python`

### How to use the template

- Clone the repo
  - Remove the `.devcontainer/ci.sh` and all the files refered in it if you don't want to use them.
- Download `JLink_Linux_V832_x86_64.deb` from the `Segger website` and place it in the `.devcontainer`
 directoy.
  - You can try this (might not work if the logic on the website changed):
        ```bash
        curl -d "accept_license_agreement=accepted&submit=Download+software" \
        -X POST \
        -o .devcontainer/JLink_Linux_V832_x86_64f.deb \
        "https://www.segger.com/downloads/jlink/JLink_Linux_V832_x86_64.deb"
        ```
- Verify the download. Run: `md5sum --check JLink_Linux_V832_x86_64.deb.md5`.
- Open the devcontainer in `VScode`

Then run this commands for a quick test:

- Run: `./build_test.sh`
- Run: `west build blinky --board nrf52840dk/nrf52840 --build-dir blinky/build --pristine`

---
