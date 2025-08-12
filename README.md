# Ansible Workstation Setup

Goal:       Multi-distro Linux workstation configuration using Ansible with minimum required complexity to get the job done

## Tasks

- [x] basic ubuntu install
- [x] factor out some distro specific vars
- [x] libvirt support client and host
- [x] add timing and disk usage output
- [x] basic docker install from docker repo https://docs.docker.com/engine/install/ubuntu/
- [ ] Linux post-installation steps for Docker Engine https://docs.docker.com/engine/install/linux-postinstall/
- [ ] yadm dotfiles support
- [ ] dotfiles dependencies
- [ ] clean up vim install, plugins, etc
- [ ] install vscode and assorted junk, codium and windsurf
- [ ] claude-desktop for linux
- [ ] mcp commander
- [ ] npm install -g @google/gemini-cli
- [ ] download/build the common dev containers
- [ ] figure out what desktop support the script should provide (display/window manager/etc) - gnome and qtile?
- [ ] figure out if/how the script should handle nvidia driver and cuda support (viz ubuntu and cachyos)

## Usage notes

To test this with local VMs using hostnames via qemu/libvirt for ssh and ansible requires:
- install libnss-libvirt and enable dns resolution of vms under libvirt by appending libvirt to /etc/resolv.conf
```sudo apt install libnss-libvirt
sudo sed -i '/^hosts:/ s/$/ libvirt/' /etc/nsswitch.conf
```
- set hostname in client

## End-state Envisioned Structure
```
├── site.yml              # Main playbook
├── inventory             # Hosts file
├── install.sh           # Run script
├── vars/                # Variables
│   ├── main.yml         # Common vars
│   ├── debian.yml       # Debian/Ubuntu specific
│   └── archlinux.yml    # Arch/CachyOS specific
├── tasks/               # OS-specific tasks
│   ├── debian/
│   └── archlinux/
└── roles/               # Role definitions
    ├── base/
    ├── development/
    ├── desktop/
    └── dotfiles/
```
