#!/bin/bash

echo "Stopping and removing the Windows container..."
docker compose -f windows10.yml down

echo "Deleting the Windows virtual disk..."
rm -rf ./windows

echo "Recreating the Windows storage folder..."
mkdir -p ./windows

echo ""
echo "Done!"
echo "The Windows VM has been removed."
echo "You can now create a fresh VM with:"
echo "docker compose -f windows10.yml create && docker compose -f windows10.yml start"
