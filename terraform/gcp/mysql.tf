data "template_file" "mysql_backup_configuration" {
  template = "${chomp(file("${path.module}/templates/mysql_backup_configuration.json"))}"

  vars {
    region = "${var.region}"
  }
}
