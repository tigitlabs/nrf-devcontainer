#!/bin/bash

if [ -z "$ZEPHYR_BASE" ]; then
  echo "⚠️ ZEPHYR_BASE is not set"
  echo "Run activate the environment"
  exit 1
fi

rm -rf blinky
cp -r ~/ncs/${NRF_TOOLCHAIN_VERSION}/zephyr/samples/basic/blinky .

nrfutil sdk-manager toolchain launch --ncs-version ${NRF_TOOLCHAIN_VERSION} -- west build blinky --board nrf52840dk/nrf52840 --build-dir blinky/build --pristine

echo "🧪 Check if the build is successful"
# Check if the hex file exists
if [ -f "blinky/build/merged.hex" ]; then
  echo "✅ Hex file exists"
else
  echo "❌ Hex file does not exist"
  exit 1
fi
