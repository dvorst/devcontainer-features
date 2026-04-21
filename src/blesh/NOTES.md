### Global install with configurable paths

`ble.sh` is installed to the directory set by the `install-dir` option. This defaults to `/usr/local/share`, which will install blesh globally, making it available to all users.

To ensure bash is run upon opening a new shell, `source ble.sh` has to be appended to a bash config. The bash config to which this source is added, is set by the `bashrc` option. This defaults to `/etc/bash.bashrc`, which is the config that is read by every bash shell. This way, ble.sh is always loaded independent of the user. The source command is defined such that ble.sh is only loaded if the shell is interactive.


### Version pinning

`ble.sh` does not follow a regular release cycle; the last tagged release was 2023-04-03, which is 2 years ago at the time of writing.
Their convention is nightly builds, which have been published since 2022-06-16.
Old nightly builds are never removed, so you can pin to a specific version:

```json
{ "nightly-build-version": "ble-nightly-20260310+b99cadb" }
```

The default (`ble-nightly`) always installs the most recent nightly build.
For available versions see: https://github.com/akinomyoga/ble.sh/releases/tag/nightly

### Temporary dependencies

`curl` (or `wget`), `tar`, and `xz` are installed if not present and removed after
the install completes, keeping the image lean.
`bash`, `awk`, `sed`, `ps`, and `ca-certificates` are installed if missing, but left in the image since bash requires these to function.

### Per-user configuration

`ble.sh` reads `~/.blerc` (or `~/.config/blesh/init.bash`) at startup.
Place `bleopt` calls and key-bindings there. The file is sourced inside a running `ble.sh`
session, so it has access to all `ble.sh` built-ins.
See the `

### Example: devcontainer.json with a named user and type-ahead hints enabled

```json
{
  "image": "mcr.microsoft.com/devcontainers/base:ubuntu",
  "features": {
    "ghcr.io/devcontainers/features/common-utils:2": {
      "username": "dev",
      "userUid": "1000",
      "userGid": "1000"
    },
    "ghcr.io/dvorst/devcontainer-features/blesh:1": {}
  },
  "remoteUser": "dev",
  "postCreateCommand": "cat > ~/.blerc <<'EOF'\n# Show history-based type-ahead suggestions (fish-style ghost text)\nbleopt complete_auto_history=1\n\n# Trigger auto-complete after every keystroke\nbleopt complete_auto_complete=1\nEOF"
}
```

`complete_auto_history` makes `ble.sh` suggest the most recent matching history entry as
greyed-out ghost text while you type; press the right-arrow key (or `End`) to accept it.
`complete_auto_complete` additionally triggers the completion menu automatically without
requiring a `Tab` press.
