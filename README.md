# PCF Paasify

Installing Pivotal Cloud Foundry for quick setups can be more complicated than it should. The goal of this project is to allow you to complete an install of PCF, with optional tiles, with nothing more than Terraform installed locally. This is being essentially being exposed as 'PCF-as-a-Terraform-module' that is compatible across all supported public clouds.

If you need fire-and-forget mechanism that gives you predictable, stable PCF environments (including many popular tiles) then this is for you.

Take this example:

```
module "paasify" {
  source = "github.com/nthomson-pivotal/pcf-paasify/terraform/aws?ref=2.4"

  env_name     = "paasify-test"
  dns_suffix   = "aws.paasify.org"
  pivnet_token = "<pivnet token here>"

  tiles = ["mysql", "rabbit", "scs"]
}
```

This will:
- Install PAS 2.4 Small Footprint
- Add MySQL, RabbitMQ and Spring Cloud Services tiles
- Wire up DNS so that its accessible at `paasify-test.aws.paasify.org`
- Provision valid SSL certificates via Lets Encrypt for every common HTTPS endpoint
- Allow you to cleanly tear down all infrastructure via `terraform destroy`
- Performs all PivNet product downloads/uploads on the OpsMan VM for faster operation

When the Terraform run completes there will be a fully working PCF PAS installation, with endpoint information available from Terraform outputs.

## What?

Paasify is a set of super-opinionated Terraform scripts and supporting utilities for creating Pivotal CloudFoundry foundations in the various supported IaaS providers. Where this utility excels in the ability to quickly setup PCF foundations for experiments or testing, and is powerful in scenarios that involve multiple foundations (multi-region or multi-cloud) as it is capable of creating these in a single command due to its composability. Other scenarios where it becomes useful are demos or proof-of-concept exercises where the focus is not on the installation procedure itself, nor is the target a "production-grade" setup.

The main features provided by the install are:

- Small Footprint PAS
- Ability to install specific tiles (supporting stemcells automatically installed)
- DNS that is configured without intervention
- Valid SSL certificates for both OpsManager and PAS via Lets Encrypt
- All default passwords are randomly generated
- Working configuration for `cf logs` and `cf ssh`
- Leverages cloud-provided blobstores by default
- AWS CloudFormation configurations that provide CodeBuild job templates

Some of the opinions of this project are:

- A very specific DNS naming convention and control structure (see below for more details)
- SSL certificates generated through LetsEncrypt via DNS verification
- Default to absolute minimal resource configurations
- As much as possible inherited from core PCF Terraforming projects for each IaaS
- Pin to known working versions of anything everywhere possible at the expense of the latest version

Pending work includes:

- Support additional tiles (PCC, SSO)
- Pre-install cloud-specific service brokers
- Install cloud-specific logging nozzles where available
- Provide easy hooks to AWS SES for outbound email support (notifications etc)
- Ability to specify syslog output for log aggregation (Papertrail etc)
- Support optionally hard-coded OpsManager password instead of always randomly generating

## Why Not Concourse/PCF-Pipelines?

This project is *NOT* intended to illustrate best practices with regards to installing PCF as advocated by Pivotal, but rather to support a very specific set of use-cases:

- I often require PCF installations on my own cloud infrastructure on short notice (demo, experiments)
- I neither want to build/maintain/pay for a Concourse setup nor start/stop one whenever I need it to reduce costs
- PCF Pipelines are architected for larger-scale, long-lived systems, whereas I have optimized for a one-click setup with less regard for upgradability

Leveraging AWS CodeBuild provides a serverless solution that allows aggressive cost control with a fire-and-forget interface.

## Usage

There are several ways to run Paasify.

### Running with Terraform

Paasify can be run directly as a Terraform module. The pre-requisites for this are:

- Terraform must be installed locally
- You must have authentication setup locally for the appropriate cloud that Terraform leverage (see Terraform provider docs)

The following example Terraform configuration imports Paasify as a module targetting AWS:

```
module "paasify" {
  source = "github.com/nthomson-pivotal/pcf-paasify/terraform/aws"

  env_name     = "test-env"
  dns_suffix   = "aws.paasify.org"
  pivnet_token = "<pivnet token>"
}
```

Currently the implementation only allows authentication already configured appropriately on the host machine. Explicitly passing in credentials for the various Terraform cloud providers is not supported.

### Running using AWS CodeBuild

This repository contains a CloudFormation template for creating AWS CodeBuild projects to build and destroy a setup. In order to create a CloudFormation stack using this template execute a command like the following:

```aws cloudformation create-stack --stack-name test-env --template-body file://catalog/cloudformation/cf.json --parameters ParameterKey=EnvName,ParameterValue=test-env ParameterKey=DnsSuffix,ParameterValue=aws.paasify.org ParameterKey=PivnetToken,ParameterValue=<pivnet token> ParameterKey=Cloud,ParameterValue=aws```

### Cleaning Up

If you're having issues cleaning up, take a look at the [leftovers](https://github.com/genevieve/leftovers) utility.

**WARNING: Use this utility with care**

For example, if you created an environment with a name of `test-env` then you could run the following command:

```leftovers --filter test-env```

Its recommended to use the `--dry-run` option first to ensure you don't delete anything unintended.

## Reference

The following sections provide more detailed information regarding the system which is created by the scripts

### Tiles

These tiles are supported:

- MySQL v2
- RabbitMQ
- Spring Cloud Services
- Redis
- PCF Metrics
- Metrics Forwarder
- Healthwatch
- Prometheus

The latest stemcell supported by each tile will automatically be uploaded to OpsManager.

### DNS

TODO

### SSL Certificates

Valid SSL certificates are generated by using Lets Encrypt via the DNS challenge protocol. If the DNS is setup as documented above then this will work transparently and will require no further input.

A single SSL certificate is generated for all necessary SANs, which results in several wildcard entries.
