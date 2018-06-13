#!/bin/bash

set -e

om -k -t https://$OM_DOMAIN stage-product -p p-metrics-forwarder -v 1.11.2
om -k -t https://$OM_DOMAIN stage-product -p apm -v 1.4.5

echo 'Configuring Metrics...'
om -t https://$OM_DOMAIN configure-product --product-name p-metrics-forwarder -pn "$METRICS_AZ_CONFIG" -pr "$METRICS_FORWARDER_RES_CONFIG"
om -t https://$OM_DOMAIN configure-product --product-name apm -pn "$METRICS_AZ_CONFIG" -pr "$METRICS_RES_CONFIG"

# Disable Metrics Forwarder smoke tests, bug causes default port to always be picked up
om -t https://$OM_DOMAIN set-errand-state -p p-metrics-forwarder -e test-metrics-forwarder --post-deploy-state disabled
