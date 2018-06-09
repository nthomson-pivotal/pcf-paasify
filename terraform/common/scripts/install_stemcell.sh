#!/bin/bash

set -e

om_username=$1
om_password=$2
version=$3

export OM_USERNAME=$om_username
export OM_PASSWORD=$om_password

object_key=$(pivnet --format=json product-files -p stemcells -r $version | jq -r '.[] | select(.name | contains("AWS")) | .aws_object_key')

if [ -z "$object_key" ]; then
  echo 'Failed to find stemcell'
  exit 1
fi

filename=$(basename /$object_key)

pivnet download-product-files --accept-eula -p stemcells -r $version -g $filename

om -k -t https://localhost upload-stemcell -f -s $filename
