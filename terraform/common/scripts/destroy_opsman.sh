#!/bin/bash

# This script unstages all products from OpsManager and runs `apply-changes` to make sure IaaS resources are cleaned up

om -k -t https://$OM_DOMAIN -u $OM_USERNAME -p $OM_PASSWORD --format json staged-products | jq -r '. as $orig | length as $len | [keys[] | $orig[$len - 1 - .]] | .[].name' | \
  while read object; do 
    om -k -t https://$OM_DOMAIN -u $OM_USERNAME -p $OM_PASSWORD unstage-product -p $object
  done

sleep 10

om -k -t https://$OM_DOMAIN -u $OM_USERNAME -p $OM_PASSWORD apply-changes