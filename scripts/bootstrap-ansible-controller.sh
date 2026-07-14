#! /usr/bin/env bash

# -e option instructs bash to immediately exit if any command  [1] has a non-zero exit status.
# -u option instructs bash to treat unset variables as an error and exit immediately.
# -o pipefail option instructs bash to return the exit status of the last command in the pipe that failed.

set -euo pipefail

# Update the systme and install dependencies
sudo dnf makecache -y

# Install required packages for Ansible Controller
sudo dnf install -y python3 python3-pip git openssh-clients ansible-core

echo "Ansible Controller setup completed successfully."

echo "Ensuring user-local Python path is enabled"
grep -qxF 'export PATH="$HOME/.local/bin:$PATH"' "$HOME/.bashrc" || echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc

echo "Validating Ansible installation"
"$HOME/.local/bin/ansible" --version