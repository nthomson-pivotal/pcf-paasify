#!/bin/bash

set -e

source ~/.om_profile

echo "Preparing to configure OpsMan..."

if [ -f "/home/ubuntu/vm_extensions.txt" ]; then
  vm_extensions=$(cat /home/ubuntu/vm_extensions.txt | tr -d '[:space:]')
  
  if [ ! -z "${vm_extensions}" ]; then
    rm -f vm-extension*
    
    csplit --digits=2  --quiet --prefix=vm-extension --suppress-matched /home/ubuntu/vm_extensions.txt "/|/" "{*}"
    
    shopt -s nullglob
    for f in vm-extension*
    do
        echo "Applying VM extension $f"
        om create-vm-extension --config $f
    done
  fi
fi

echo 'Configuring OpsMan...'
om configure-director -c /home/ubuntu/config/opsman-config.yml --ops-file /home/ubuntu/config/opsman-config-ops.yml

om apply-changes -n p-bosh