#!/bin/bash

set -e

om_username=$1
om_password=$2
product_slug=$3
version=$4
glob=$5
iaas=$6
om_product=$7

export OM_USERNAME=$om_username
export OM_PASSWORD=$om_password

if [ -z "$om_product" ]; then
  om_product=$product_slug
fi

check_payload=$(om -k -t https://localhost -f json available-products)

if [ "$check_payload" != "no available products found" ]; then
  check=$(echo $check_payload | jq ".[] | select(.name==\"$om_product\" and .version==\"$version\") | .name")
fi

if [ -z "${check}" ]; then
  echo "Installing tile $product_slug v$version..."

  if [ ! -f "$filename" ]; then
    echo "Downloading product from PivNet..."

    pivnet download-product-files --accept-eula -p $product_slug -r $version -g "*$glob*"
  else
    echo "Using cached product file"
  fi

  filename=$(basename $(pivnet --format json product-files -p $product_slug -r $version | jq --arg v "$glob" -r '.[] | select(.aws_object_key | contains($v)) | .aws_object_key'))

  echo "Uploading to OpsMan..."

  om -k -t https://localhost upload-product -p $filename

  echo "Installed tile $product_slug v$version"
  
else
  echo "Tile $product_slug v$version is already installed"
fi

om_version=$(om --format json -k -t https://localhost available-products  | jq -r ".[] | select(.name==\"$om_product\") | .version")

if [ -z "$om_version" ]; then
  echo "Error: Failed to find available product in OM named $om_product"
  exit 1
fi

echo "Staging product version $om_version for $om_product in OM available products..."

om -k -t https://localhost stage-product -p $om_product -v $om_version

echo 'Looking up stemcell dependency...'
stemcell=$(pivnet release-dependencies -p $product_slug -r $version | grep -m 1 Stemcells | cut -d '|' -f 3 | awk '{$1=$1};1')

if [ -z "$stemcell" ]; then
  echo "Couldn't find stemcell dependency"
  exit 1
else
  echo "Installing stemcell $stemcell for $iaas..."
  install_stemcell $om_username $om_password $stemcell $iaas
fi
