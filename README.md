# Ansible Workstation Setup

Goal:       Multi-distro Linux workstation configuration using Ansible

## Status

- At this point in time the script runs without failing on Ubuntu Server 24.04, Debian 13, CachyOS (all tested in vm)
- Test experience:
    - Ubuntu Server: very clunky on 25.04 with random segfaults of fairly innocent processes (almost every session). Better on 24.04. vanilla-gnome package still has some ubuntu crap in it. Even desnappified, apt install muscle memory can get tripped up and needs flatpak. Remains to be seen how much value Ubuntu's good integration with nVidia and extensive security options really add. Conclusion: Ubuntu continues to move away from the central Linux/GNU philosophy for the desktop user
    - Debian 13: works very smoothly for this type of approach. As expected.
    - CachyOS: highly configured out of the box, and very well so. Some setups much simpler, since Arch and AUR provide many packages. Pacman contibuted to fastest install times. Very pleasant first time Arch experience. Configuring it seems simpler than Debian.
- My current dotfiles approach is destructive and Debian centric. It works fine on bare Debian or Ubuntu installs, but does not work well on an already highly configured offering like CachyOS. An options would be to make dotfiles setup incremental and conditional, but this is hard to do idempotently.
- Conclusions:
    - Ubuntu a big disappointment, CachyOS a beast
    - Nvidia setups not portable and change frequency is greater than merrits automation here. Latter also for most AI/LLM stuff.
    - Automate commonly used container setup with a flexible backup/restore strategy

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
