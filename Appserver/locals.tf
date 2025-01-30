locals {
    resource_group_location         = "Central India"

    app_nic_name                    = "app-nic"
    ip_config_name                  = "internal"

    key_path                        = "~/.ssh/id_rsa.pub"
    caching                         = "ReadWrite"
    storage_account_type            = "Standard_LRS"

    web_nic_name                    = "web-nic"
    ip_config                       = "external"
}