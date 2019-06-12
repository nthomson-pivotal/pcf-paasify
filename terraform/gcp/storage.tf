resource "google_storage_bucket" "backup" {
  name          = "${var.project}-${var.env_name}-backup"
  location      = "${var.buckets_location}"
  force_destroy = true
}