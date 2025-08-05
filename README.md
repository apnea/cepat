# Ansible Workstation Setup

Multi-distro Linux workstation configuration using Ansible.

## Structure
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

## Usage
```bash
./install.sh
```

## Supported Distributions
- Debian/Ubuntu
- Arch Linux/CachyOS