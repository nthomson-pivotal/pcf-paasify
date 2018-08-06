module "nat" {
  source = "GoogleCloudPlatform/nat-gateway/google"

  version = "1.1.11"

  name         = "paasify-${var.env_name}-"
  region       = "${var.region}"
  network      = "${module.gcp.network_name}"
  subnetwork   = "${module.gcp.pas_subnet_name}"
  machine_type = "n1-standard-2"
  tags         = ["worker", "master"]
}
