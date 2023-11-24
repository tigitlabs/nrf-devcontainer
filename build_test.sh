#!/bin/bash
# build_test.sh

if [ -z "$ZEPHYR_BASE" ]; then
  echo "⚠️ ZEPHYR_BASE is not set"
  echo "Run activate the environment"
  exit 1
fi

cp -r ~/ncs/v2.5.0/zephyr/samples/hello_world/ .
west build hello_world --board nrf52840dk_nrf52840 --build-dir hello_world/build --pristine

echo "🧪 Check if the build is successful"
# Check if the hex file exists
if [ -f "hello_world/build/zephyr/zephyr.hex" ]; then
  echo "✅ Hex file exists"
else
  echo "❌ Hex file does not exist"
  exit 1
fi
