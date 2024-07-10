# Bash support module

This module includes a `.bashrc` and sets up a `.bashrc.d/` folder for
additional configuration.

Largely inspired by [Sensible Bash][1] and the [Gentoo Bash][2] startup files.
It should be fast, especially on a 20+ year old machine.  Hence, no SCM/git
integrations.  (Note to self: use `git status` and practice your attention
span.)

This modules facilitates GPG and SSH agents via [`keychain`][3].

[1]: https://github.com/mrzool/bash-sensible
[2]: https://gitweb.gentoo.org/repo/gentoo.git/tree/app-shells/bash/files
[3]: https://www.funtoo.org/Keychain

## Dependencies

[`keychain`][3].  It's in [most][4] distro repos.

[4]: https://repology.org/project/keychain/versions

## The prompt

Inspired by the standard Gentoo Bash prompt, this prompt offers enhancements:

1. Current command in titlebar
2. Otherwise the prompt in the titlebar
3. Exit code in bold red at the start if non-zero
4. Spaces between most elements in the prompt, ensuring readability despite
   illegible typefaces.
