#!/bin/bash

set -e

om -k -t https://$OM_DOMAIN stage-product -p p-spring-cloud-services -v 1.5.2

echo 'Configuring SCS...'
om -t https://$OM_DOMAIN configure-product --product-name p-spring-cloud-services -p "$SCS_PRODUCT_CONFIG" -pn "$AZ_CONFIG"
