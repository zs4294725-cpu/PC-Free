#!/bin/bash

set -euo pipefail

cd "$(dirname "$0")"

FILE="windows10.yml"
MODE="${1:-}"

if [ -z "$MODE" ]; then
  echo "Select boot mode for the next Windows VM start:"
  echo "  1) UEFI (windows)"
  echo "  2) UEFI Secure (windows_secure)"
  echo "  3) Legacy (windows_legacy)"
  echo ""
  read -p "Choice [1-3]: " CHOICE
else
  CHOICE="$MODE"
fi

case "$CHOICE" in
  1|windows|uefi|u)
    BOOT_MODE="windows"
    ;;
  2|windows_secure|secure|s)
    BOOT_MODE="windows_secure"
    ;;
  3|windows_legacy|legacy|l)
    BOOT_MODE="windows_legacy"
    ;;
  *)
    echo "Invalid choice: $CHOICE"
    exit 1
    ;;
esac

if [ ! -f "$FILE" ]; then
  echo "Error: $FILE was not found in $(pwd)."
  exit 1
fi

if grep -q '^      BOOT_MODE:' "$FILE"; then
  sed -i.bak -E "s|^      BOOT_MODE: \".*\"|      BOOT_MODE: \"$BOOT_MODE\"|" "$FILE"
else
  echo "Error: BOOT_MODE line not found in $FILE."
  exit 1
fi

rm -f "$FILE.bak"

echo "Boot mode set to $BOOT_MODE in $FILE."
