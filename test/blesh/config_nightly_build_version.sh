#!/bin/bash
set -eu

# shellcheck source=/dev/null
. ./dev-container-features-test-lib

VERSION="0.4.0-nightly+7cf1387"

get-version() {
	# Load bashrc and get blesh version
	# cannot use `bash -i -c "source $BASHRC && echo $BLE_VERSION"` because:
	# 	ble.sh bails out when BASH_EXECUTION_STRING is set (bash -c), so the command must be run
	#	via a script file.
	# cannot use `bash -i "$_tmp_script_file` because:
	#	ble.sh bails out when the process is not connected to a TTY, so `script -qec` is used
	#	which does have TTY attached. `bash -i` is still needed too
	# tail -n 1: only return the echo version, without potential messages from sourcing ble.sh
	# tr -d '\r' removes the carriage return
	# script
	#	-q: suppres script started/done header/footer that script normally prints
	#	-e: exit code passthrough
	#	-c: take argument to run as command instead of spawning an interactive shell
	_tmp_script_file=$(mktemp)
	# shellcheck disable=SC2016
	printf 'echo $BLE_VERSION' > "${_tmp_script_file}"
	script -qec "bash -i $_tmp_script_file" /dev/null | tail -n 1 | tr -d '\r'
}

echo "---"
get-version
echo "==="
check "ble.sh version" test "$(get-version)" = "${VERSION}"

reportResults