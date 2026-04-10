#!/bin/bash
set -eu

# shellcheck source=/dev/null
. ./dev-container-features-test-lib

INSTALL_DIR="/usr/local/share"
BASHRC="/etc/bash.bashrc"

bashrc_line='[[ $- == *i* ]] && source '"$INSTALL_DIR"'/blesh/ble.sh'

check "ble.sh is installed" test -f "${INSTALL_DIR}/blesh/ble.sh"
check "ble.sh is readable" test -r "${INSTALL_DIR}/blesh/ble.sh"
check "bash.bashrc exists" test -f "${BASHRC}"
check "bash.bashrc contains integration line" grep --fixed-strings --quiet "${bashrc_line}" "${BASHRC}"
check "ble.sh can be loaded by bash" bash -c '. /usr/local/share/blesh/ble.sh --noattach'

reportResults
