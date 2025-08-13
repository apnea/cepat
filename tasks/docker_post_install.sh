#!/bin/bash
# Linux post-installation steps for Docker Engine
# https://docs.docker.com/engine/install/linux-postinstall/

# Manage Docker as a non-root user
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker
docker run hello-world

# Configure Docker to start on boot with systemd
sudo systemctl enable docker.service
sudo systemctl enable containerd.service
