#!/bin/bash

set -e

terraform destroy -var 'env_name=niall' -var 'project=fe-nthomson' -var 'pivnet_token=9d5sppPU4zLzCgXB_k3V' -var 'root_dns_zone=pcf-zone' -input=false -auto-approve
