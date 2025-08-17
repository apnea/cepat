#!/bin/bash
# Host preparation script for Ansible playbook execution
#
# On a fresh trixie install you may need
# sudo sed -i '/cdrom/d' /etc/apt/sources.list
# printf "deb http://deb.debian.org/debian trixie main contrib non-free-firmware\ndeb http://deb.debian.org/debian trixie-updates main contrib non-free-firmware\ndeb http://security.debian.org/debian-security trixie-security main contrib non-free-firmware\ndeb http://deb.debian.org/debian trixie-backports main contrib non-free-firmware\n" | sudo tee /etc/apt/sources.list > /dev/null
# sudo apt install git
# 
# Once done with installs, remove the proxy:
# sudo rm /etc/apt/apt.conf.d/80proxy
# sudo sed -i '/http_proxy/d' /etc/environment

HOST=$(awk -F= '/^ID=/ {print $2}' /etc/os-release | tr -d '"')
VERSION_CODENAME=$(awk -F= '/^VERSION_CODENAME=/ {print $2}' /etc/os-release | tr -d '"')
PROXY="http://192.168.68.127:3128"
PLAYBOOK="https://github.com/apnea/cepat.git"
USEPROXY=true

printf "Detected host as $HOST and version as $VERSION_CODENAME"
printf "Proxy set to $PROXY"

printf "\nTesting proxy...\n"
printf "IP address: " && curl -x "$PROXY" ip.me

printf "\nPreparing host for Ansible playbook execution...\n"

case "$HOST" in
    ubuntu)
        if [ "$USEPROXY" = true ]; then
            echo "Acquire::http::Proxy \"$PROXY\";" | sudo tee /etc/apt/apt.conf.d/80proxy
            echo "http_proxy=\"$PROXY\"" | sudo tee -a /etc/environment
        fi
        sudo apt update
        sudo apt install -y software-properties-common
        sudo add-apt-repository --yes --update ppa:ansible/ansible
        sudo apt install -y ansible ansible-lint
        sudo apt install -y python3-pip
        ;;
    debian)
        if [ "$USEPROXY" = true ]; then
            echo "Acquire::http::Proxy \"$PROXY\";" | sudo tee /etc/apt/apt.conf.d/80proxy
            echo "http_proxy=\"$PROXY\"" | sudo tee -a /etc/environment
        fi
        sudo apt update
        sudo apt install -y ansible ansible-lint        ;;
    cachyos)
        echo "http_proxy=\"$PROXY\"" | sudo tee -a /etc/environment
        echo "https_proxy=\"$PROXY\"" | sudo tee -a /etc/environment
        sudo pacman -Syu --noconfirm
        sudo pacman -S --noconfirm ansible ansible-lint
        ;;
    *)
        echo "Unsupported host: $HOST"
        exit 1
        ;;
esac

printf "\nAnsible version is: %s\n" "$(ansible --version)"

mkdir ~/src

printf "\nCloning playbook repository...\n"
git clone $PLAYBOOK ~/src/cepat
cd ~/src/cepat || exit 1
printf "\nDone! You can now run the playbook with:\n"
echo "ansible-playbook -i inventory site.yml --limit local --ask-become-pass"
