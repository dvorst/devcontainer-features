#!/bin/bash
set -eu

# shellcheck source=/dev/null
. ./dev-container-features-test-lib
# shellcheck source=/dev/null
. "$(dirname "$0")/blesh_helpers.bash"

RCFILE="/workspaces/some-project/.blerc"  # see scenarios.json

# NOTE: variable name _ble_base_rcfile might change in the future, see
#		https://github.com/akinomyoga/ble.sh/blob/master/ble.pp
# shellcheck disable=SC2016
check "ble.sh rcfile" test "$(run-in-blesh-shell 'echo $_ble_base_rcfile')" = "${RCFILE}"

reportResults
