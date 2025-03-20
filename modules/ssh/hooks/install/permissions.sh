#!/bin/sh

set -eu

chmod 0700 "$TARGET/.ssh"

# chmod -f still returns 1 exit code if file does not exist, so just create it
# anyways.  Also, use touch -a to only update access time if file already
# exists.  Helpful for auditing when the file has changed.
touch -a "$TARGET/.ssh/authorized_keys"
chmod 0600 "$TARGET/.ssh/authorized_keys"
