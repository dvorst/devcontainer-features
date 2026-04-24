# ble.sh Feature Notes

[ble.sh](https://github.com/akinomyoga/ble.sh) (Bash Line Editor) provides:
-   syntax highlighting: such as highlighting an incorrectly typed command in red
-   autocompletion
-   and multiline editing.

## Installation
### with configuration

-   Create a blesh config file in your project dir `.devcontainer/.blerc`
    [docs](https://github.com/akinomyoga/ble.sh/blob/master/blerc.template)
    for example:
    ```bash
    # Show history-based type-ahead suggestions (fish-style ghost text)
    bleopt complete_auto_history=1

    # Trigger auto-complete after every keystroke
    bleopt complete_auto_complete=1
    ```
-   Then add the feature to your `devcontainer.json`
    ```json
    "features": {
        "ghcr.io/dvorst/devcontainer-features/blesh:1": {
            "rcfile": "/workspaces/<your-project-name>/.devcontainer/.blerc"
        }
    }
    ```
    > NOTE: If you mount your workspace differently, you will need to adjust the path.
-   Once installed, ble.sh is automatically active in every new interactive Bash session.


### Without configuration
-   For a quick install without blerc config file add this to you devcontainer.json
    ```json
    "features": {
        "ghcr.io/dvorst/devcontainer-features/blesh:1": {}
    }
    ```

## Supported OS
The following OS'es should be supported
- debian
- ubuntu
- alpine
- fedora
- centos
- oraclelinux
- rockylinux
- almalinux
- amazonlinux
- azurelinux
- redhat UBI
- opensuse
- archlinux

## Version Pinning

`ble.sh` does not follow a regular release cycle; the last tagged release was 2023-04-03,
which is 3 years ago at the time of writing.
Their convention is nightly builds, which have been published since 2022-06-16.
Old nightly builds are never removed, so you can pin to a specific version:

```json
"nightly-build-version": "ble-nightly-20260310+b99cadb"
```

The default (`ble-nightly`) always installs the most recent nightly build.
For available versions see: https://github.com/akinomyoga/ble.sh/releases/tag/nightly


## install-dir & bashrc

`ble.sh` is installed to the directory set by the `install-dir` option.
This defaults to `/usr/local/share`, which will install blesh globally,
making it available to all users.

To ensure bash is run upon opening a new shell, `source ble.sh` has to be appended to a bash config.
The bash config to which this source is added, is set by the `bashrc` option.
This defaults to `/etc/bash.bashrc`, which is the config that is read by every bash shell.
This way, ble.sh is always loaded independent of the user.
The source command is defined such that ble.sh is only loaded if the shell is interactive.


## Dependencies

`curl` (or `wget`), `tar`, and `xz` are installed if not present and removed after
the install completes, keeping the image lean.

`bash`, `awk`, `sed`, `ps`, and `ca-certificates` are installed if missing, but left in the image
since blesh requires these to function, but does not install these itself.
