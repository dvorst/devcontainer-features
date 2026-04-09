# TODO: parameterize the install location and bashrc to use
# TODO: extend script to verify that root is used for the global install

### Installed globally
`ble.sh` is installed to `/usr/local/share` instead of `~/.local/share`.
Sourcing blesh is done in `/etc/bash.bashrc` instead of `~/.bashrc`.
This way, it does notmatter if root or user installs it,
plus it leaves the option to install `ble.sh` before a user is even created.

### Version pinning
`ble.sh` does not follow a propper release cycle.
The latest release was back in 2023-04-03 which is 3 years ago at the moment of writing.
Their current convention is to create a nightly build,
which seems to have been the standard since 2022-06-16.
They do not remove old nightly builds, so to pin ble.sh to a specific version, you can specify:
```json
{"nightly-build-version": "ble-nightly-20260310+b99cadb"}
```
The default is to use their latest nightly build (`ble-nightly`)
For an overview of their nightly build versions, see:
    https://github.com/akinomyoga/ble.sh/releases/tag/nightly
