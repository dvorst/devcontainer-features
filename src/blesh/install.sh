#!/bin/sh
set -eu

# --------------------------------------------------------------------------------------------------
# Functions

has() { command -v "$1" >/dev/null 2>&1; }

# Download a file from a URL to a destination path
# Prefers curl; falls back to wget with BusyBox detection
download() {
    _url="$1"
    _dest="$2"
    if has curl; then
        curl --fail --location --proto '=https' --tlsv1.2 --output "$_dest" "$_url"
    # BusyBox wget (Alpine) does not support --secure-protocol; GNU wget does
    # BusyBox grep only supports short flags: -F (fixed-strings), -q (quiet, return 0 if found)
    elif wget --version 2>&1 | grep -Fq 'BusyBox'; then
        wget --output-document "$_dest" "$_url"
    else
        wget --secure-protocol=TLSv1_2 --output-document "$_dest" "$_url"
    fi
}

# Install a package using whatever package manager is available
pkg_install() {
    if has apt-get; then     # Debian, Ubuntu
        apt-get update
        apt-get install --yes "$@"
    elif has apk; then       # Alpine
        apk add --no-cache "$@"
    elif has tdnf; then      # Azure Linux (Mariner)
        tdnf install --assumeyes --refresh "$@"
    elif has dnf; then       # Fedora, RHEL 8+, CentOS Stream, Oracle Linux, Rocky, AlmaLinux
        dnf install --assumeyes --refresh "$@"
    elif has yum; then       # RHEL 7, CentOS 7, Amazon Linux
        yum makecache
        yum install --assumeyes "$@"
    elif has zypper; then    # openSUSE
        zypper refresh
        zypper install --non-interactive "$@"
    elif has pacman; then    # Arch Linux
        pacman --sync --refresh --noconfirm "$@"
    elif has nix-env; then  # NixOS
        for _pkg in "$@"; do
            nix-env --install --attr "nixpkgs.$_pkg"
        done
    else
        echo "Error: no supported package manager found" >&2
        exit 1
    fi
}

# Remove a package using whatever package manager is available
pkg_remove() {
    if has apt-get; then     # Debian, Ubuntu
        apt-get purge --yes "$@"
        apt-get autoremove --yes
    elif has apk; then       # Alpine
        apk del --purge "$@"
    elif has tdnf; then      # Azure Linux (Mariner)
        tdnf remove --assumeyes "$@"
        tdnf autoremove --assumeyes
    elif has dnf; then       # Fedora, RHEL 8+, CentOS Stream, Oracle Linux, Rocky, AlmaLinux
        dnf remove --assumeyes "$@"
        dnf autoremove --assumeyes
    elif has yum; then       # RHEL 7, CentOS 7, Amazon Linux
        yum remove --assumeyes "$@"
        yum autoremove --assumeyes
    elif has zypper; then    # openSUSE
        zypper remove --non-interactive --clean-deps "$@"
    elif has pacman; then    # Arch Linux
        pacman --remove --nosave --recursive --noconfirm "$@"
    elif has nix-env; then   # NixOS
        nix-env --uninstall "$@"
    else
        echo "Error: no supported package manager found" >&2
        exit 1
    fi
}

# Clean package manager caches
pkg_clean() {
    if has apt-get; then     # Debian, Ubuntu
        apt-get clean
        rm -rf /var/lib/apt/lists/*
    elif has apk; then       # Alpine
        rm -rf /var/cache/apk/*
    elif has tdnf; then      # Azure Linux (Mariner)
        tdnf clean all
    elif has dnf; then       # Fedora, RHEL 8+, CentOS Stream, Oracle Linux, Rocky, AlmaLinux
        dnf clean all
    elif has yum; then       # RHEL 7, CentOS 7, Amazon Linux
        yum clean all
    elif has zypper; then    # openSUSE
        zypper clean --all
    elif has pacman; then    # Arch Linux
        pacman --sync --clean --noconfirm
    fi
}

# --------------------------------------------------------------------------------------------------
# Install permanent tools

# bash is required to run the ble.sh installer and to use ble.sh at runtime
if ! has bash; then
    pkg_install bash
fi

# ps is required by ble.sh at runtime; Alpine busybox provides it by default
if ! has ps; then
    if has apt-get; then     # Debian, Ubuntu
        pkg_install procps
    elif has tdnf; then      # Azure Linux (Mariner)
        pkg_install procps-ng
    elif has dnf; then       # Fedora, RHEL 8+, CentOS Stream, Oracle Linux, Rocky, AlmaLinux
        pkg_install procps-ng
    elif has yum; then       # RHEL 7, CentOS 7, Amazon Linux
        pkg_install procps-ng
    elif has zypper; then    # openSUSE
        pkg_install procps
    elif has pacman; then    # Arch Linux
        pkg_install procps-ng
    elif has nix-env; then   # NixOS
        pkg_install procps
    fi
fi

# --------------------------------------------------------------------------------------------------
# Install temporary tools


# Ensure a download tool is available; prefer curl
_installed_curl=false
if ! has curl && ! has wget; then
    pkg_install curl
    _installed_curl=true
fi

# Ensure tar is available
_installed_tar=false
if ! has tar; then
    if has nix-env; then  # NixOS: GNU tar is packaged as 'gnutar'
        pkg_install gnutar
    else
        pkg_install tar
    fi
    _installed_tar=true
fi

# Ensure xz decompression is available (package name differs per distro)
# Note: busybox tar has xz support built in and does not require the xz binary,
_installed_xz=false
_xz_pkg=""
#       but GNU tar requires xz to be installed separately.
if ! has xz; then
    if has apt-get; then  # Debian, Ubuntu: package is named 'xz-utils'
        pkg_install xz-utils
        _xz_pkg="xz-utils"
    else
        pkg_install xz
        _xz_pkg="xz"
    fi
    _installed_xz=true
fi

# --------------------------------------------------------------------------------------------------
# Cleanup failed run (mostly useful for testing purposes)

# Clean up any leftovers from a previous failed run
rm -rf /tmp/blesh /tmp/blesh.tar.xz


# --------------------------------------------------------------------------------------------------
# Install ble.sh

# Download
url="https://github.com/akinomyoga/ble.sh/releases/download/nightly/${NIGHTLY_BUILD_VERSION}.tar.xz"
download "$url" /tmp/blesh.tar.xz

# Extract
# busybox tar does not support `tar --one-top-level`, so the dir is created manually
mkdir -p /tmp/blesh
# busybox tar only supports short flags: -x (extract), -J (xz decompress), -f (file), -C (directory)
tar -xJf /tmp/blesh.tar.xz \
    --strip-components=1 \
    -C /tmp/blesh
rm /tmp/blesh.tar.xz

# Install
bash /tmp/blesh/ble.sh --install "$INSTALL_DIR"
rm -rf /tmp/blesh

# verify file exists to catch silent install failure
# ble.sh may exit 0 even when installation fails (this is at least the case for missing runtime dependencies)
test -f "${INSTALL_DIR}/blesh/ble.sh" || { echo "Error: ble.sh installation failed" >&2; exit 1; }

# Set up shell integration in /etc/bash.bashrc
BASHRC_LINE='[[ $- == *i* ]] && source '"${INSTALL_DIR}"'/blesh/ble.sh'
touch "$BASHRC"
# busybox grep does not support long flags; use short flags -F (fixed-strings) and -q (quiet)
if ! grep -Fq "$BASHRC_LINE" "$BASHRC"; then
    printf '\n%s\n' "$BASHRC_LINE" >> "$BASHRC"
fi

# --------------------------------------------------------------------------------------------------
# Cleanup

if [ "$_installed_curl" = true ]; then pkg_remove curl; fi
if [ "$_installed_tar" = true ]; then pkg_remove tar; fi
if [ "$_installed_xz" = true ]; then pkg_remove "$_xz_pkg"; fi
pkg_clean