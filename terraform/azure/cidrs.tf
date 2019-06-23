

module "cidr_calculator" {
  source = "github.com/pivotal-cf/terraforming-aws?ref=3f77c15//modules/calculate_subnets"

  vpc_cidr = "${var.vpc_cidr}"
}