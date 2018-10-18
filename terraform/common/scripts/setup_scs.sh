#!/bin/bash

set -e

om -t https://$OM_DOMAIN configure-product --product-name p-spring-cloud-services -p "$SCS_PRODUCT_CONFIG" -pn "$AZ_CONFIG"
