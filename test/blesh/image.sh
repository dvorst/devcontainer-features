#!/bin/bash

set -eu

# shellcheck source=/dev/null
. ./dev-container-features-test-lib

# Shared checks for a default blesh install.
# Sourced by per-image scenario scripts after dev-container-features-test-lib is loaded.

INSTALL_DIR="/usr/local/share"
BASHRC="/etc/bash.bashrc"

bashrc_line='[[ $- == *i* ]] && source '"$INSTALL_DIR"'/blesh/ble.sh'

check "ble.sh is installed" test -f "${INSTALL_DIR}/blesh/ble.sh"
check "ble.sh is readable" test -r "${INSTALL_DIR}/blesh/ble.sh"
check "bashrc exists" test -f "${BASHRC}"

# busybox grep only supports shorthand flags
#	-F: literal strings, not regex
#	-q: quiet, returns 0 if found, 1 otherwise.
check "bashrc contains bashrc_line" grep -Fq "${bashrc_line}" "${BASHRC}"

# --lib will 'Only load ble.sh and do nothing else', so it does not attach to the terminal session,
#	allowing it to be run in a non-interactive/non-TTY environment
check "ble.sh can be loaded by bash" bash -c "source ${INSTALL_DIR}/blesh/ble.sh --lib"

check "ble.sh version is non-empty" \
	bash -c "source ${INSTALL_DIR}/blesh/ble.sh --lib && test -n \"\$BLE_VERSION\""

reportResults