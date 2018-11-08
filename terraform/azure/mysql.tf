resource "azurerm_storage_container" "cf_mysql_storage_container" {
  name                  = "mysqlbackup"
  resource_group_name   = "${module.azure.pcf_resource_group_name}"
  storage_account_name  = "${module.azure.cf_storage_account_name}"
  container_access_type = "private"
}

data "template_file" "mysql_backup_configuration" {
  template = "${chomp(file("${path.module}/templates/mysql_backup_configuration.json"))}"

  vars {
    access_key = "${module.azure.cf_storage_account_access_key}"
    account = "${module.azure.cf_storage_account_name}"
    container_name = "${azurerm_storage_container.cf_mysql_storage_container.name}"
  }
}
