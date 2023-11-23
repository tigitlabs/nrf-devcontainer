#!/bin/bash
# build_test.sh

west init -m https://github.com/nrfconnect/ncs-example-application --mr main my-workspace
cd my-workspace
west update
west build -b custom_board app -- -DOVERLAY_CONFIGg.conf
