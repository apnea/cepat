#!/bin/bash

# Desnap the system and prevent snappification
snap list --all | tail -n +2 | awk '{print $1}' | xargs -r sudo snap remove --purge
snap list
sudo systemctl stop snapd
sudo systemctl disable snapd
sudo systemctl mask snapd
sudo apt purge snapd -y
sudo apt-mark hold snapd
sudo cat <<EOF | sudo tee /etc/apt/preferences.d/nosnap.pref
Package: snapd
Pin: release a=*
Pin-Priority: -10
EOF

# clean up snappies
rm -rf ~/snap/
sudo rm -rf /snap
sudo rm -rf /var/snap
sudo rm -rf /var/lib/snapd