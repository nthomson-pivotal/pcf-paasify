# PCF Paasify

This project provides a wrapper utility around the PCF Terraform scripts that completely automates the installation of PCF in several cloud providers:

- AWS
- Azure (WIP)

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
