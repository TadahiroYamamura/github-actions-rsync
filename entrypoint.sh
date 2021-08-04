#!/bin/sh

set -eu

# Set deploy key
SSH_PATH="$HOME/.ssh"
mkdir -p "$SSH_PATH"
echo "$SSH_PRIVATE_KEY" > "$SSH_PATH/deploy_key"
chmod 600 "$SSH_PATH/deploy_key"

# Create SSH config file
touch "$SSH_PATH/config"
echo "Host rsync_target"                   >> "$SSH_PATH/config"
echo "  HostName $SSH_HOSTNAME"            >> "$SSH_PATH/config"
echo "  User $SSH_USERNAME"                >> "$SSH_PATH/config"
echo "  IdentityFile $SSH_PATH/deploy_key" >> "$SSH_PATH/config"
echo "  Port ${SSH_PORT:-22}"              >> "$SSH_PATH/config"
echo "  StrictHostKeyChecking no"          >> "$SSH_PATH/config"

# Do deployment
sh -c "rsync ${INPUT_RSYNC_OPTIONS} ${GITHUB_WORKSPACE}${INPUT_RSYNC_SOURCE} rsync_target:${INPUT_RSYNC_TARGET}"
