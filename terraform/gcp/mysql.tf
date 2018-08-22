data "template_file" "mysql_backup_configuration" {
  template = "${chomp(file("${path.module}/templates/mysql_backup_configuration.json"))}"

  vars {
    project = "${var.project}"
    bucket_name = "${google_storage_bucket.mysql_backup.name}"
    service_account_json = "${jsonencode(base64decode(google_service_account_key.key.private_key))}"
  }
}

resource "google_storage_bucket" "mysql_backup" {
  name          = "${var.project}-${var.env_name}--mysql-backup"
  # TODO: Change below to variable/map
  location      = "US"
  force_destroy = true
}