# Ansible Workstation Setup

Goal:       Multi-distro Linux workstation configuration using Ansible

## Tasks

- [x] basic ubuntu package installs
- [x] factor out some distro specific vars
- [x] libvirt support client and host
- [x] add timing and disk usage output
- [x] basic docker install from docker repo https://docs.docker.com/engine/install/ubuntu/
- [x] Linux post-installation steps for Docker Engine https://docs.docker.com/engine/install/linux-postinstall/
- [x] add ansible linting to prod level
- [x] refactor to roles
- [x] yadm dotfiles support
- [x] dotfiles dependencies
- [x] clean up vim install, plugins, etc
- [x] remove snap
- [x] flatpak + apps
- [x] gnome setup with themes, fonts, extensions for Debian/Ubuntu
- [x] refactor detection to distinguish Ubuntu vs Debian vs Arch
- [x] split vars/debian.yml into separate ubuntu.yml and debian.yml
- [x] refactor containerization role for Ubuntu/Debian/Arch differences
- [x] refactor package_management role for distro-specific handling
- [x] refactor desktop role for Ubuntu/Debian/Arch GNOME differences
- [x] test on Ubuntu Server 24.04, Debian 13, CachyOS -> partial success!
- [ ] fix dot files mechanism
- [ ] add nvidia driver and cuda support detection/installation
- [ ] add development role (vscode, codium, windsurf, dev tools)
- [ ] add ai_tools role (claude-desktop, gemini-cli, mcp-commander)
- [ ] add virtualization role (enhanced libvirt, qemu setup)
- [ ] install dockge and the commonly used dockers, such as beszel, dozzle, ollama, webui, walkietalkie, etc
- [ ] install vscode and assorted junk, codium and windsurf
- [ ] claude-desktop for linux
- [ ] mcp commander
- [ ] npm install -g @google/gemini-cli
- [ ] download/build the common dev containers

## Usage notes

To test this with local VMs using hostnames via qemu/libvirt for ssh and ansible requires:

1. install libnss-libvirt and enable dns resolution of vms under libvirt by appending libvirt to /etc/resolv.conf


```
    sudo apt install libnss-libvirt
    sudo sed -i '/^hosts:/ s/$/ libvirt/' /etc/nsswitch.conf
```

2. set hostname in client

You can also do all this just using ip addresses.

Usage: ./test-vm.sh will create a vm, attempt to connect to it via hostname, run the script asking for a sudo password, and then destroy the vm.

Testing note: Run a squid to cache the apt and other http requests originating from the script:

vm: ```echo 'Acquire::http::Proxy "http://<host-ip>:3128";' | sudo tee /etc/apt/apt.conf.d/80proxy``` and  ```http_proxy=http://<host-ip>:3128``` in /etc/environment

host: ```virsh net-dumpxml default``` to find IP range for acl (also check squid access log if denied). Ensure big enough cache in squid.conf.

## End-state
```
├── site.yml                # Main playbook
├── inventory               # Hosts file
├── install.sh              # Run script
├── vars/                   # Variables
│   ├── common_packages.yml
│   ├── common_flatpaks.yml
│   ├── debian.yml          # Debian/Ubuntu specific
│   └── archlinux.yml       # Arch/CachyOS specific
├── tasks/                  # Legacy task files (to be removed)
└── roles/                  # Feature-focused roles
    ├── base/
    ├── containerization/   # Docker + container ecosystem
    │   └── tasks/
    │       ├── main.yml
    │       ├── debian.yml
    │       ├── archlinux.yml
    │       ├── post_install.yml
    │       └── log_rotation.yml
    ├── package_management/  # Package ecosystem management
    │   └── tasks/
    │       ├── main.yml
    │       ├── debian.yml
    │       ├── archlinux.yml
    │       └── flatpak.yml
    ├── development/
    ├── desktop/
    └── dotfiles/
```
