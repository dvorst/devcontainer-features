#!/bin/bash
set -eu

# shellcheck source=/dev/null
. ./dev-container-features-test-lib

RCFILE="/workspaces/devcontainer-features/doc/.blerc"

# script allocates a pseudo-TTY so ble.sh fully initialises; without one it detects
# no terminal and bails out. bash -i makes $- contain 'i', satisfying the interactive
# guard that the install wrote into /etc/bash.bashrc.
# script -e passes through the exit code of the command; -q suppresses header/footer.
check "ble.sh rcfile is set correctly" \
    script -qec "bash -i -c 'test \"\$(bleopt rcfile)\" = \"${RCFILE}\"'" /dev/null

reportResults
