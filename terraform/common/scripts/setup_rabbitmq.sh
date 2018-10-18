#!/bin/bash

set -e

om -t https://$OM_DOMAIN configure-product --product-name p-rabbitmq -p "$PRODUCT_CONFIG" -pn "$AZ_CONFIG" -pr "$RABBITMQ_RES_CONFIG"
