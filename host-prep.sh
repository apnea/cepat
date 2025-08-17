#!/bin/bash
# Host preparation script for Ansible playbook execution
#
# On a fresh trixie install you may need
# printf "deb http://deb.debian.org/debian trixie main contrib non-free-firmware\ndeb http://deb.debian.org/debian trixie-updates main contrib non-free-firmware\ndeb http://security.debian.org/debian-security trixie-security main contrib non-free-firmware\ndeb http://deb.debian.org/debian trixie-backports main contrib non-free-firmware\n" | sudo tee /etc/apt/sources.list > /dev/null
# sudo apt install git

HOST=$(awk -F= '/^ID=/ {print $2}' /etc/os-release | tr -d '"')
VERSION_CODENAME=$(awk -F= '/^VERSION_CODENAME=/ {print $2}' /etc/os-release | tr -d '"')
PROXY="http://192.168.68.127:3128"
PLAYBOOK="https://github.com/apnea/cepat.git"
USEPROXY=true

echo "Detected host as $HOST and version as $VERSION_CODENAME"
echo "Proxy set to $PROXY"

echo "\nTesting proxy..."
echo "IP address: " && curl -x $PROXY ip.me

echo "\nPreparing host for Ansible playbook execution..."

case "$HOST" in
    ubuntu)
        sudo apt update
        sudo apt install -y software-properties-common
        sudo add-apt-repository --yes --update ppa:ansible/ansible
        sudo apt install -y ansible ansible-lint
        sudo apt install -y python3-pip
        if [ "$USEPROXY" = true ]; then
            echo "Acquire::http::Proxy $PROXY;" |sudo tee /etc/apt/apt.conf.d/80proxy
            echo "http_proxy $PROXY;" | sudo tee /etc/environment
        fi
        ;;
    debian)
        sudo apt update
        sudo apt install -y ansible ansible-lint
        if [ "$USEPROXY" = true ]; then
            echo "Acquire::http::Proxy $PROXY;" |sudo tee /etc/apt/apt.conf.d/80proxy
            echo "http_proxy $PROXY;" | sudo tee /etc/environment
        fi
        ;;
    arch)
        sudo pacman -Sy ansible ansible-lint
        ;;
    *)
        echo "Unsupported host: $HOST"
        exit 1
        ;;
esac

echo "\n Ansible version is $(ansible --version)"

mkdir ~/src

echo "\nCloning playbook repository..."
git clone $PLAYBOOK ~/src/cepat
cd ~/src/cepat || exit 1
echo "\Done! You can now run the playbook with:"
echo "ansible-playbook -i inventory site.yml --limit local --ask-become-pass"
