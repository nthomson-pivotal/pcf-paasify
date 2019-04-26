#!/bin/bash

set -e

source ~/.om_profile

om_product=$1
version=$2
iaas=$3
url=$4

filename="$om_product-$version"

if [ ! -f "$filename" ]; then
  echo "Downloading $om_product tile..."
  wget -q -O $filename $url
else
  echo "Using cached product file"
fi

om upload-product -p $filename

om stage-product -p $om_product -v $version