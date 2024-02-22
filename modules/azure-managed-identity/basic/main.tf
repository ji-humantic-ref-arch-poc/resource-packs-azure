locals {
  # Name restrictions https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/resource-name-rules
  default_name = trimsuffix(lower(substr("${var.prefix}${var.app_id}-${var.env_id}-${replace(var.res_id, ".", "-")}", 0, 128)), "-")
}

data "azurerm_resource_group" "main" {
  name = var.resource_group_name
}

resource "azurerm_user_assigned_identity" "main" {
  name                = coalesce(var.name, local.default_name)
  resource_group_name = data.azurerm_resource_group.main.name
  location            = data.azurerm_resource_group.main.location

  tags = {
    "managed-by" = "terraform"
    "humanitec"  = "true"
    "hum-app"    = var.app_id
    "hum-env"    = var.env_id
    "hum-res"    = var.res_id
  }
}
