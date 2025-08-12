#!/bin/bash
set -euo pipefail

BASE_VM="ubuntu25.04-server-clone"
TEST_VM="testbox"
PLAYBOOK="site.yml"

echo "Cloning $TEST_VM from $BASE_VM"
virt-clone --original "$BASE_VM" --name "$TEST_VM" --auto-clone

echo "Starting $TEST_VM"
virsh start "$TEST_VM"

echo "Getting IP"
IP=""
for i in {1..30}; do
  IP=$(virsh domifaddr "$TEST_VM" 2>/dev/null | awk '/ipv4/ {print $4}' | cut -d/ -f1)
  [ -n "$IP" ] && break
  sleep 2
done
echo $IP

if [ -z "$IP" ]; then
  echo "Failed to get IP for $TEST_VM"
  exit 1
fi

echo "Waiting fo SSH to be ready"
for i in {1..30}; do
  nc -z "$IP" 22 && break
  sleep 2
done

ansible-playbook -i "$IP," "$PLAYBOOK" --ask-become-pass

echo "Destroy and undefine"
virsh destroy "$TEST_VM"
virsh undefine "$TEST_VM" --remove-all-storage
