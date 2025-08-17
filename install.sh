#!/bin/bash
# Workstation setup script
# Usage: ./install.sh [local|remote]

if [ "$1" = "local" ]; then
    echo "Running local installation..."
    ansible-playbook -i inventory site.yml --limit local --ask-become-pass
elif [ "$1" = "remote" ] || [ -z "$1" ]; then
    echo "Running remote installation..."
    ansible-playbook -i inventory site.yml --ask-become-pass
else
    echo "Usage: $0 [local|remote]"
    echo "  local  - Install on localhost"
    echo "  remote - Install on remote hosts (default)"
    exit 1
fi

gsettings get org.gnome.desktop.interface gtk-theme
gsettings get org.gnome.desktop.interface icon-theme
gsettings get org.gnome.desktop.interface cursor-theme
gsettings get org.gnome.desktop.interface font-name
