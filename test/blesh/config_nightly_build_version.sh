#!/bin/bash
set -eu

# shellcheck source=/dev/null
. ./dev-container-features-test-lib

INSTALL_DIR="/usr/local/share"
VERSION="0.4.0-nightly+7cf1387"

BLE_VERSION=$(bash -c "source ${INSTALL_DIR}/blesh/ble.sh --lib && echo \$BLE_VERSION")
echo "BLE_VERSION=${BLE_VERSION}"

check "ble.sh version" test "${BLE_VERSION}" = "${VERSION}"

reportResults
