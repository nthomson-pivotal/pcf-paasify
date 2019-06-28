#!/bin/bash

set -e

source ~/.om_profile

product_slug=$1
version=$2
glob=$3
iaas=$4
om_product=$5

lock_file=/var/run/paasify.lock

if [ -z "$om_product" ]; then
  om_product=$product_slug
fi

tile_files="files/${product_slug}/$version"
metadata_filename="${tile_files}/download-file.json"

check_staged_payload=$(om staged-products -f json | jq -r ".[] | select(.name==\"$om_product\") | .version")

if [ -z "$check_staged_payload" ]; then
  check_available_payload=$(om available-products -f json)

  if [ "$check_available_payload" != "no available products found" ]; then
    check=$(echo $check_available_payload | jq ".[] | select(.name==\"$om_product\" and .version==\"$version\") | .name")
  fi

  if [ -z "${check}" ]; then
    echo "Installing tile $product_slug v$version..."

    if [ ! -f "$metadata_filename" ]; then
      echo "Downloading product from PivNet..."

      if [ ! -d "$tile_files" ]; then
        mkdir -p $tile_files
      fi

      pivnet accept-eula -p $product_slug -r $version

      om download-product -p $product_slug -f "*$glob*" -r $version --stemcell-iaas $iaas --pivnet-api-token $PIVNET_TOKEN -o $tile_files

      #pivnet download-product-files --accept-eula -p $product_slug -r $version -g "*$glob*"
    else
      echo "Using cached product file"
    fi

    echo "Uploading to OpsMan..."

    filename=$(cat $metadata_filename | jq -r '.product_path')

    flock $lock_file -c "om -t https://localhost -k upload-product -p $filename"

    echo "Installed tile $product_slug v$version"
    
  else
    echo "Tile $product_slug v$version is already installed"
  fi

  om_version=$(om available-products -f json | jq -r ".[] | select(.name==\"$om_product\") | .version")

  if [ -z "$om_version" ]; then
    echo "Error: Failed to find available product in OM named $om_product"
  fi

  if [ -z "$NO_STAGE" ]; then
    # Temp fix for race condition
    sleep 10

    echo "Staging product version $om_version for $om_product in OM available products..."

    om stage-product -p $om_product -v $om_version
  else
    echo "Skipping staging $om_product"
  fi
else
  echo "Product $om_product $om_version is already staged"
fi

stemcell_path=$(cat $metadata_filename | jq -r '.stemcell_path')

flock $lock_file -c "om -t https://localhost -k upload-stemcell -f -s $stemcell_path"