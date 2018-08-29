#!/bin/bash

set -e

om_username=$1
om_password=$2

filename="prometheus-0.1.0.pivotal"

if [ ! -f "$filename" ]; then
  echo "Downloading Prometheus Dev tile..."
  wget https://storage.googleapis.com/prometheus-tile-dev/$filename
fi

om -k -t https://localhost upload-product -p $filename
