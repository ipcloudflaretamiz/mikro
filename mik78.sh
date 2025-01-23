#!/bin/bash -e

echo
echo "=== ipcloudflaretamiz.org ==="
echo "=== https://github.com/ipcloudflaretamiz ==="
echo "=== MikroTik 7 Installer ==="
echo
sleep 3

# Download the file
wget https://download.mikrotik.com/routeros/7.17/all_packages-arm-7.17.zip -O chr.img.zip || { echo "Download failed"; exit 1; }

# Unzip the file instead of using gunzip
unzip chr.img.zip || { echo "Extraction failed"; exit 1; }

# Locate the storage device
STORAGE=$(lsblk | grep disk | awk '{print $1}' | head -n 1)
echo "STORAGE is $STORAGE"

# Get network information
ETH=$(ip route show default | sed -n 's/.* dev \([^\ ]*\) .*/\1/p')
echo "ETH is $ETH"
ADDRESS=$(ip addr show $ETH | grep global | awk '{print $2}' | head -n 1)
echo "ADDRESS is $ADDRESS"
GATEWAY=$(ip route list | grep default | awk '{print $3}')
echo "GATEWAY is $GATEWAY"

# Wait before writing to disk
sleep 5

# Write the image to disk
dd if=chr.img of=/dev/$STORAGE bs=4M oflag=sync || { echo "Disk write failed"; exit 1; }
echo "Ok, reboot"
echo 1 > /proc/sys/kernel/sysrq
echo b > /proc/sysrq-trigger
