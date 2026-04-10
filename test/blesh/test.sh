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
# --lib will 'Only load ble.sh and do nothing else', so it does not attach to the terminal session, allowing it to be run in a non-interactive/non-TTY environment
check "ble.sh can be loaded by bash" bash -c "source ${INSTALL_DIR}/blesh/ble.sh --lib"

reportResults
