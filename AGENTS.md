# Ansible Workstation Setup - Agent Guidelines

## Build/Lint/Test Commands

```bash
# Lint Ansible playbooks and roles
ansible-lint

# Run the full playbook (remote hosts)
ansible-playbook -i inventory site.yml --ask-become-pass

# Run on localhost only
ansible-playbook -i inventory site.yml --limit local --ask-become-pass

# Run a specific role
ansible-playbook -i inventory site.yml --tags containerization --ask-become-pass

# Syntax check only
ansible-playbook -i inventory site.yml --syntax-check

# Test with a VM (requires libvirt setup)
./test-vm.sh
```

## Code Style Guidelines

### Module Naming
- Use Fully Qualified Collection Names (FQCN): `ansible.builtin.*`, `community.general.*`
- Prefer core modules over shell commands when possible
- Always specify module arguments as key-value pairs, not positional

### File Organization
- Main playbook: `site.yml` - orchestrates roles
- Roles in `roles/<role_name>/tasks/` with distro-specific files: `debian.yml`, `ubuntu.yml`, `archlinux.yml`
- Main role task file (`main.yml`) uses `include_tasks` to load distro-specific files
- Variables in `vars/` - split by distro: `debian.yml`, `ubuntu.yml`, `archlinux.yml`, `common_*.yml`
- Pre-execution tasks in `pre_tasks/` - distro detection and setup

### Distro-Specific Logic
- `distro_name` fact set in `pre_tasks/main.yml` maps Ubuntu/Pop/Mint → `ubuntu`, Debian → `debian`, Arch/CachyOS → `archlinux`
- Use `include_tasks: "{{ distro_name }}.yml"` pattern for distro-specific task inclusion
- Load distro-specific vars with `include_vars: "vars/{{ distro_name }}.yml"`
- Test distro detection with debug tasks before conditional logic

### Variable Naming
- Snake_case for all variables: `my_user`, `distro_packages`, `containerization_docker_hello_world_result`
- Register results use prefix with role name: `role_name_descriptive_name`
- Reference vars in task names for clarity: `"Clone dotfiles repository with yadm (first time)"`

### Task Structure
- Every task has a descriptive name explaining what it does
- Register outputs with meaningful names
- Always set `changed_when` for command/shell tasks to prevent false positives
- Use `failed_when: false` for commands that legitimately fail (e.g., checks)
- Use `when:` conditionals for conditional execution
- Multi-line strings use `>-` block scalars for readability
- Boolean values are lowercase: `true`, `false`

### Privilege Escalation
- Use `become: true` for privileged operations
- Use `become_user: "{{ my_user }}"` for user-specific operations
- `become: false` for desktop/gsettings tasks (run as regular user)

### Comments
- Inline comments explain non-obvious choices: `# Note: The GPG key needs to go into .asc not .gpg`
- Section comments use `---` followed by description: `---\n# Docker installation for Debian`

### Error Handling
- Check command outputs with `when:` conditions before dependent tasks
- Use `stat` module to check file/directory existence
- Implement fallback logic (e.g., force clone if initial clone fails)
- Commands that should not change state use `changed_when: false`

### Loops
- Use `loop:` with item lists from variables
- Clear variable names: `common_distro_packages`, `distro_packages`

### Idempotency
- Use `creates:` parameter for command/shell tasks
- Check state before acting (e.g., `stat` before `command`)
- Avoid destructive operations without checks

### Formatting
- 2-space indentation for YAML
- List items indented under `name:`, `when:`, `become:`, etc.
- Long strings use block scalars (`>-`) for readability
- Keep lines under 120 characters when practical

### Import vs Include
- Use `include_tasks` for dynamic inclusion (variables allowed)
- Use `include_vars` for variable files
- Prefer static structure over dynamic where possible

### GNOME Configuration
- Use `community.general.dconf` module for GNOME settings
- Run without `become` (as regular user) for gsettings/dconf changes
- Group related settings logically (fonts, themes, extensions, configuration)
