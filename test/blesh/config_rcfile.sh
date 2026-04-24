#!/bin/bash
set -eu

# shellcheck source=/dev/null
. ./dev-container-features-test-lib

RCFILE="/workspaces/some-project/.blerc"  # see scenarios.json


get-bleopt-rcfile() {
	# Load bashrc and get blesh rcfile
	# cannot use `bash -i -c "bleopt rcfile"` because:
	# 	ble.sh bails out when BASH_EXECUTION_STRING is set (bash -c), so the command must be run
	#	via a script file.
	# cannot use `bash -i "$_tmp_script_file` because:
	#	ble.sh bails out when the process is not connected to a TTY, so `script -qec` is used
	#	which does have TTY attached. `bash -i` is still needed too
	# script
	#	-q: suppres script started/done header/footer that script normally prints
	#	-e: exit code passthrough
	#	-c: take argument to run as command instead of spawning an interactive shell
	# tail -n 1: return only the rcfile, no messages from sourcing ble.sh
	# tr -d '\r' removes the carriage return
	# NOTE: variable name _ble_base_rcfile might change in the future, see
	#		https://github.com/akinomyoga/ble.sh/blob/master/ble.pp
	_tmp_script_file=$(mktemp)
	printf 'echo $_ble_base_rcfile' > "${_tmp_script_file}"
	script -qec "bash -i $_tmp_script_file" /dev/null | tail -n 1 | tr -d '\r'
}

check "ble.sh rcfile" test "$(get-bleopt-rcfile)" = "${RCFILE}"

reportResults
