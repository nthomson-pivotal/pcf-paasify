# PCF Paasify

Paasify is a set of super-opinionated Terraform scripts and supporting utilities for creating PCF installations in the various supported IaaS providers. This is mainly intended for demo, testing or PoC setups where the installer has complete control.

Some of the opinions of this project are:

- A very specific DNS naming convention and control structure (see below for more details)
- SSL certificates generated through LetsEncrypt

The core of the functionality is provided by the Pivotal-authored Terraform configuration files.

The main features provided by the install are:

- Small Footprint PAS
- Several tiles pre-installed with reduced VM footprint
- Valid SSL certificates for both OpsManager and PAS
- Working configuration for `cf logs` and `cf ssh`

## Tiles Installed

The following tiles are installed by default:

- MySQL v2
- RabbitMQ
- Spring Cloud Services
- PCF Metrics
- Metrics Forwarder
- Healthwatch
