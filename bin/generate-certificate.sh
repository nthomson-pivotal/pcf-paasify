#!/bin/bash

set -e

path=$HOME/state/lego

if [ ! -d "$path/certificates" ]; then
  echo "Obtaining certificate..."

  lego --accept-tos --path=$path --email="none@paasify.org" -d pcf.$env.$dns_suffix -d *.apps.$env.$dns_suffix -d *.sys.$env.$dns_suffix -d *.uaa.sys.$env.$dns_suffix --dns="route53" run
else
  echo "Renewing certificate if necessary..."
  lego --accept-tos --path=$path --email="none@paasify.org" -d pcf.$env.$dns_suffix -d *.apps.$env.$dns_suffix -d *.sys.$env.$dns_suffix -d *.uaa.sys.$env.$dns_suffix --dns="route53" renew --days 30
fi
