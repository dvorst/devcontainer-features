#!/bin/bash
# Helpers for running expressions inside a ble.sh-loaded bash shell.

run-in-blesh-shell() {
	# Evaluate a shell expression inside a ble.sh-loaded interactive bash session.
	#
	# cannot use `bash -i -c "..."` because:
	# 	ble.sh bails out when BASH_EXECUTION_STRING is set (bash -c), so the command must be run
	#	via a script file.
	# cannot use `bash -i "$_tmp_script_file"` because:
	#	ble.sh bails out when the process is not connected to a TTY, so `script -qec` is used
	#	which does have TTY attached, `bash -i` is still needed though to run an interactive shell.
	# script flags:
	#	-q: suppress script started/done header/footer that script normally prints
	#	-e: exit code passthrough
	#	-c: take argument to run as command instead of spawning an interactive shell
	# tr -d '\r': remove carriage returns added by script's PTY
	local _tmp_script_file
	_tmp_script_file=$(mktemp)
	# SC2016: expressions passed as arguments are intentionally single-quoted so the caller
	# controls expansion, not this function.
	# shellcheck disable=SC2016
	printf '%s' "$1" > "${_tmp_script_file}"
	script -qec "bash -i ${_tmp_script_file}" /dev/null | tr -d '\r'
	rm -f "${_tmp_script_file}"
}

get-blesh-var() {
	# Read the value of a variable from a ble.sh-loaded interactive bash session.
	# $1: variable name
	# tail -n 1: discard ble.sh startup messages, keep only the echoed value
	run-in-blesh-shell "echo \$$1" | tail -n 1
}
