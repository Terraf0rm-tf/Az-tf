terraform {
    backend "azurerm" {
        resource_group_name  = "From_TF"
        storage_account_name = "tfstorgacc"
        container_name       = "tfwebappcontainer"
        key                  = "terraform.tfstate"
    }
}