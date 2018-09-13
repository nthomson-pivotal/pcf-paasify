#!/bin/bash

# This script unstages all products from OpsManager and runs `apply-changes` to make sure IaaS resources are cleaned up

# TODO: If theres nothing to remove then don't apply changes, it will fail

counter=0

om -k -t https://$OM_DOMAIN -u $OM_USERNAME -p $OM_PASSWORD --format json staged-products | jq -r '. as $orig | length as $len | [keys[] | $orig[$len - 1 - .]] | .[].name' | \
  while read object; do 
    om -k -t https://$OM_DOMAIN -u $OM_USERNAME -p $OM_PASSWORD unstage-product -p $object
    counter=$((counter+1))
  done

sleep 10

# Only apply changes if we unstaged at least one product
if [ "$counter" -gt "0" ]; then
  om -k -t https://$OM_DOMAIN -u $OM_USERNAME -p $OM_PASSWORD apply-changes
else
  echo "Skipping apply changes..."
fi
