#!/bin/bash

set -e

om_username=$1
om_password=$2
slug=$3
version=$4
iaas=$5

export OM_USERNAME=$om_username
export OM_PASSWORD=$om_password

object_key=$(pivnet --format=json product-files -p $slug -r $version | jq --arg v "$iaas" -r '.[] | select(.aws_object_key | contains($v)) | .aws_object_key')

if [ -z "$object_key" ]; then
  echo 'Failed to find stemcell'
  exit 1
fi

filename=$(basename /$object_key)

if [ ! -f "$filename" ]; then
  echo "Downloading stemcell $version..."
  pivnet download-product-files --accept-eula -p $slug -r $version -g $filename
else
  echo "Stemcell $version already downloaded"
fi

om -k -t https://localhost upload-stemcell -f -s $filename
