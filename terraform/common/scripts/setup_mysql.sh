#!/bin/bash

set -e

om -t https://$OM_DOMAIN configure-product --product-name pivotal-mysql -p "$PRODUCT_CONFIG" -pn "$AZ_CONFIG" -pr "{}"
