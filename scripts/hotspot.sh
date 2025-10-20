#!/bin/bash

# 🔥 This script creates and starts a Wi-Fi hotspot using nmcli.

SSID="Fedora"             # Replace with your desired SSID
PASSWORD="Password@12345" # Replace with your desired password (I am lazy)
WIFI_IFACE=$(nmcli device | awk '$2 == "wifi" && $1 !~ /^p2p/ {print $1; exit}')

if [ -z "$WIFI_IFACE" ]; then
    echo "❌ No valid Wi-Fi interface found."
    exit 1
fi

# Delete old hotspot if exists
nmcli connection delete Fedora-hotspot >/dev/null 2>&1

# Create a new hotspot
nmcli connection add type wifi ifname "$WIFI_IFACE" mode ap con-name Fedora-hotspot ssid "$SSID"
nmcli connection modify Fedora-hotspot wifi.band bg
nmcli connection modify Fedora-hotspot wifi.channel 1
nmcli connection modify Fedora-hotspot ipv4.method shared
nmcli connection modify Fedora-hotspot wifi-sec.key-mgmt wpa-psk
nmcli connection modify Fedora-hotspot wifi-sec.psk "$PASSWORD"

# Start the hotspot
nmcli connection up Fedora-hotspot

echo "✅ Hotspot '$SSID' started on interface $WIFI_IFACE"
