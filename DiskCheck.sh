#!/bin/bash

echo "=== Disk Space Check ==="
df -h

echo
echo "=== Docker Storage ==="
docker system df

echo
echo "=== Windows VM Storage ==="
du -sh ~/windows 2>/dev/null || echo "Windows VM folder not found"
