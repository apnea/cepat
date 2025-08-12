#!/bin/bash
set -euo pipefail

BASE_VM="ubuntu25.04-server-clone"
TEST_VM="testbox"
PLAYBOOK="playbook.yml"

echo "Cloning $TEST_VM from $BASE_VM"
# Clone from base
virt-clone --original "$BASE_VM" --name "$TEST_VM" --auto-clone

echo "Starting $TEST_VM"
# Start VM
virsh start "$TEST_VM"

echo "Getting IP"
# Get IP (via DHCP lease lookup)
IP=""
for i in {1..30}; do
  IP=$(virsh domifaddr "$TEST_VM" 2>/dev/null | awk '/ipv4/ {print $4}' | cut -d/ -f1)
  [ -n "$IP" ] && break
  sleep 2
done
echo $IP

exit 1

if [ -z "$IP" ]; then
  echo "Failed to get IP for $TEST_VM"
  exit 1
fi

echo "Waiting fo SSH to be ready"
for i in {1..30}; do
  nc -z "$IP" 22 && break
  sleep 2
done

# Run Ansible playbook
# ansible-playbook -i "$IP," "$PLAYBOOK"
ansible -i

echo "Destroy and undefine"
virsh destroy "$TEST_VM"
virsh undefine "$TEST_VM" --remove-all-storage
