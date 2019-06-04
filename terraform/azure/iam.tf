resource "azurerm_azuread_application" "paasify" {
  name = "paasify-${var.env_name}"
}

resource "azurerm_azuread_service_principal" "paasify" {
  application_id = "${azurerm_azuread_application.paasify.application_id}"
}

resource "random_string" "client_secret" {
  length = 16
  special = true
}

resource "azurerm_role_assignment" "paasify" {
  scope                = "/subscriptions/${data.azurerm_client_config.current.subscription_id}"
  role_definition_name = "Contributor"
  principal_id         = "${azurerm_azuread_service_principal.paasify.id}"
}

resource "azurerm_azuread_service_principal_password" "paasify" {
  depends_on           = ["azurerm_role_assignment.paasify"]

  service_principal_id = "${azurerm_azuread_service_principal.paasify.id}"
  value                = "${random_string.client_secret.result}"
  end_date             = "2090-01-01T00:00:00Z"

  provisioner "local-exec" {
    # Azure seems to take a while to propagate AAD stuff, so sleep for a while
    command = "sleep 20"
  }
}