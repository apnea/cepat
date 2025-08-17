# Debian Nvidia notes
# Need to determine cuda version based on card GP104

sudo apt update
sudo apt -t trixie-backports install nvidia-driver firmware-misc-nonfree
sudo apt install linux-headers-$(uname -r) build-essential dkms

nvidia-smi

curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit.gpg
curl -s -L https://nvidia.github.io/libnvidia-container/stable/debian13/nvidia-container-toolkit.list | \
  sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list
sudo apt update

sudo apt install nvidia-container-toolkit

sudo nvidia-ctk runtime configure --runtime=docker
sudo systemctl restart docker

docker run --rm --gpus all nvidia/cuda:12.6.2-base-ubuntu22.04 nvidia-smi

sudo apt -t trixie-backports install nvidia-driver firmware-misc-nonfree