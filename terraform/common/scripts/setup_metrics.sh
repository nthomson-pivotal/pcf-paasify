#!/bin/bash

set -e

echo 'Configuring Metrics...'
om -t https://$OM_DOMAIN configure-product --product-name p-metrics-forwarder -pn "$METRICS_AZ_CONFIG" -pr "$METRICS_FORWARDER_RES_CONFIG"
om -t https://$OM_DOMAIN configure-product --product-name apmPostgres -pn "$METRICS_AZ_CONFIG" -pr "$METRICS_RES_CONFIG"
