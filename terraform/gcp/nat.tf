resource "google_compute_router" "router" {
  name    = "paasify-${var.env_name}-router"
  region  = "${var.region}"
  network = "${module.gcp.network_name}"

  bgp {
    asn = 64514
  }
}

resource "google_compute_router_nat" "nat" {
  name                               = "paasify-${var.env_name}-nat"
  router                             = "${google_compute_router.router.name}"
  region                             = "${var.region}"
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
} 