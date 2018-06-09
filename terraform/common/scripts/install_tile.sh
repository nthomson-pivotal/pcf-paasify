#!/bin/bash

set -e

om_username=$1
om_password=$2
product_slug=$3
version=$4
filename=$5
om_product=$6

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
    echo "Downloading product from pivnet..."

    pivnet download-product-files --accept-eula -p $product_slug -r $version -g $filename
  else
    echo "Using cached product file"
  fi

  echo "Uploading to OpsMan..."

  om -k -t https://localhost upload-product -p $filename

  echo "Installed tile $product_slug v$version"
else
  echo "Tile $product_slug v$version is already installed"
fi
