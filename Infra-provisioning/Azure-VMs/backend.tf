terraform {
    backend "azurerm" {
        resource_group_name  = local.resource_group_name
        storage_account_name = local.storage_account_name
        container_name       = local.container_name
        key                  = local.key
    }
}