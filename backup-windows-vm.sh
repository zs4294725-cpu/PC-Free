#!/bin/bash

VM_NAME="windows"
VM_FOLDER="$HOME/windows"
BACKUP_FOLDER="$HOME/vm-backups"

DATE=$(date +"%Y-%m-%d-%H-%M")
BACKUP_FILE="$BACKUP_FOLDER/windows-backup-$DATE.tar.gz"

mkdir -p "$BACKUP_FOLDER"

echo "Stopping Windows VM..."
docker stop "$VM_NAME"

echo
echo "Creating backup..."
tar -czvf "$BACKUP_FILE" "$VM_FOLDER"

echo
echo "Starting Windows VM..."
docker start "$VM_NAME"

echo
echo "Backup complete!"
echo "Saved to:"
echo "$BACKUP_FILE"
