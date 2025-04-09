# Scripts

Most scripts are written in `bash`.  Others in Perl or Python.  Some scripts
include SystemD services.

## `wpass`

`pass` companion tool to streamline common workflows.  It should _NOT_ on a
graphical desktop environment to work.

`wpass` can find entries, streamline copy-paste username followed by password,
and pipe entries to a pager.

Future revision might include entry generation using `pwgen`.

### Dependencies
Requires `fzf`, `pass` and its dependencies, `xclip`, `wl-clipboard`, `tmux`,
`less` for best experience.

## `toggle-ipv6`

Toggle IPv6 via the Linux kernel sysctl interface.

### Dependencies

`sudo` and `sysctl`.

## `geoip`

Approximate your current location via Internet-facing IP address.

### Dependencies

perl 5.

## `git-prune`

Prune all branches no longer on any remotes.

## `cuesplit`

Split a flac image with cue file into individual track files.  Heavily modified
from somebody's original work.  Source?  I forgot.

### Dependencies

Read the file I forgot.

## `upgrade`

Upgrade my hosts.

### Dependencies

`sudo`.

A Debian or Gentoo host.

Optionally `flatpak` and `snap`.

## `0x0`

Quick and dirty script to send stdin to [0x0.st][0x0].

### Dependencies

`curl`.

### See also

`wgetpaste` and friends.

[0x0]: https://0x0.st/

## `generate-recovery-archive`

Generate a GPG encrypted tarball to recover from a Borgmatic-configured Borg
repository.

### Dependencies

Read the script it's thing.

## `sync-user-data`

Syncronize user configuration comprised of git repos and actions to perform
afterwards.

Example `~/.config/sync-user-data/sync-user-data.yaml`:

```yaml
# All paths are relative to homedir.
repos:
  - p/dotfiles
  - p/debian-for-winny
  - .emacs.d
  - .password-store
commands:
  - cd p/dotfiles && make install  # Update user configuration
  - cd p/debian-for-winny && make  # Update host configuration
  - software everything  # Update host OS
```

### Dependencies

Python3 and `pyyaml xdg click` Python packages.

## `cleansignal`

Work around https://github.com/flathub/org.signal.Signal/issues/751

### Dependencies

lsof

### Run hourly

It's automatically enabled [1], but if it didn't work
try:

```bash
systemctl enable cleansignal.timer
```

[1]: hooks/install/systemd.bash

## `lightdark`

### Dependencies

Bash, KDE, using the Breeze light and dark themes, alacritty.

### Run hourly

```bash
systemctl enable lightdark.timer
```
