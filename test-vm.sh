#!/bin/bash
# Quick test setup for CachyOS VM
ansible-playbook -i inventory site.yml --ask-become-pass --limit localhost