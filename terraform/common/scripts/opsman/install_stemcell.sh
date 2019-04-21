#!/bin/bash

set -e

source ~/.om_profile

slug=$1
version=$2
iaas=$3

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

om upload-stemcell -f -s $filename
