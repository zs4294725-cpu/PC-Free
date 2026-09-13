#!/bin/bash

echo "=== Creating VM Tools ==="

mkdir -p /tmp/windows
mkdir -p ~/vm-backups

echo "Created /tmp/windows"
echo "Created ~/vm-backups"

echo
echo "=== Creating Disk Check Script ==="

cat > disk-check.sh <<'EOF'
#!/bin/bash

echo "=== Disk Space ==="
df -h

echo
echo "=== Docker Usage ==="
docker system df

echo
echo "=== Windows VM Folder ==="
du -sh /tmp/windows 2>/dev/null || echo "VM folder not found"
EOF


echo
echo "=== Creating VM Backup Script ==="

cat > backup-windows-vm.sh <<'EOF'
#!/bin/bash

DATE=$(date +"%Y-%m-%d-%H-%M")
BACKUP="$HOME/vm-backups/windows-$DATE.tar.gz"

echo "Stopping Windows VM..."

docker stop windows 2>/dev/null

echo "Creating backup..."

tar -czvf "$BACKUP" /tmp/windows

echo "Starting Windows VM..."

docker start windows 2>/dev/null

echo
echo "Backup complete:"
echo "$BACKUP"
EOF


chmod +x disk-check.sh
chmod +x backup-windows-vm.sh

echo
echo "Done!"
echo "Run disk check:"
echo "./disk-check.sh"
echo
echo "Backup VM:"
echo "./backup-windows-vm.sh"
