#!/bin/bash

echo "====================================="
echo " Creating Windows VM"
echo "====================================="

if [ ! -f "windows10.yml" ]; then
    echo "Error: windows10.yml was not found in the current directory."
    exit 1
fi

echo ""
echo "Creating container..."
docker compose -f windows10.yml create

if [ $? -ne 0 ]; then
    echo ""
    echo "Container creation failed."
    exit 1
fi

echo ""
echo "Starting container..."
docker compose -f windows10.yml start

if [ $? -ne 0 ]; then
    echo ""
    echo "Container failed to start."
    exit 1
fi

echo ""
echo "Windows VM is running."
echo ""

docker ps --filter "name=pc-free-windows"

echo ""
echo "To watch the logs, run:"
echo "docker logs -f pc-free-windows"
