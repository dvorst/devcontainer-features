#!/bin/bash
set -eu

# shellcheck source=/dev/null
. ./dev-container-features-test-lib

BLESH_INSTALL_DIR="/usr/local/share/blesh"
BASH_BASHRC="/etc/bash.bashrc"
BLESH_BASHRC_LINE='[[ $- == *i* ]] && source /usr/local/share/blesh/ble.sh'

check "ble.sh is installed" test -f "${BLESH_INSTALL_DIR}/ble.sh"
check "ble.sh is readable" test -r "${BLESH_INSTALL_DIR}/ble.sh"
check "bash.bashrc exists" test -f "${BASH_BASHRC}"
check "bash.bashrc contains integration line" grep --fixed-strings --quiet "${BLESH_BASHRC_LINE}" "${BASH_BASHRC}"
check "ble.sh can be loaded by bash" bash -c '. /usr/local/share/blesh/ble.sh --noattach'

reportResults
