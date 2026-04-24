#!/bin/bash
set -eu

# shellcheck source=/dev/null
. ./dev-container-features-test-lib
# shellcheck source=/dev/null
. "$(dirname "$0")/blesh_helpers.bash"

VERSION="0.4.0-nightly+7cf1387"

# shellcheck disable=SC2016
check "ble.sh version" test "$(run-in-blesh-shell 'echo $BLE_VERSION')" = "${VERSION}"

reportResults