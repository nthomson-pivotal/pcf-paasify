#!/bin/bash

set -e

terraform apply -var 'env_name=niall' -var 'project=fe-nthomson' -var 'pivnet_token=9d5sppPU4zLzCgXB_k3V' -var 'root_dns_zone=pcf-zone' -input=false -auto-approve

opsman_target=$(terraform output opsman_target)
opsman_password=$(terraform output opsman_password)

pas_admin_password=$(om -t $opsman_target -u admin -p $opsman_password -f json credentials -p cf -c .uaa.admin_credentials | jq '.password' -r)
