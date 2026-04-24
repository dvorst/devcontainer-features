
Checklist
- prefer sh scripts over bash, except for tests, since `devcontainer features test` requires bash
- shell script adhere to ShellCheck and shfmt standards
- shell scripts are able to run on
  - Alpine Linux
  - Debian, Ubuntu, and other debian based distros
  - Fedora
  - Red Hat Enterprise Linux (RHEL)
  - Busybox
  - Amazon Linux
  - Azure Linux
  - Distroless (Google)
  - Oracle Linux
  - Rocky Linux / AlmaLinux
  - CentOS
  - Arch
  - openSUSE
  - NixOS
- tools installed by shell scripts for temporary purpose, are cleaned up after
- separate config from logic
- Linux conventions are followed
- downloaded files for temporary purposes, are downloaded to /tmp
- downloaded files that are not used anymore afterwards are cleaned up
- if part of a shell script is specific to a certain distro, the distro(s) is/are added with a comment
- Avoid nesting config files in scripts, keeping these in separate files allows for easier linting
- shell scripts should be idempotent
- in shell, longflags are prefered over shortflags where possible, to improve readability. But do
  note that most build-in busybox commands only support shorthand flags. Explain the shorthand
  flags when used.
- Apply proper software engineering princples:
  - Don't Repeat Yourself
  - Keep It Simple
  - Single Responsibility
  - Fail Fast