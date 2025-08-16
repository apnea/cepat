#!/bin/bash
# Local installation script for workstation setup
ansible-playbook -i inventory site.yml --limit local --ask-become-pass
