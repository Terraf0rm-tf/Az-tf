locals {
    resource_group_name             = "From_Legion"
    resource_group_location         = "Central India"

    sql_server_name                 = "mysequalservr"
    sql_server_version              = "12.0"
    administrator_login             = "tfdevops"
    administrator_login_password    = "Targaryen@789"

    sql_db_name                     = "dbfortf"
    db_sku_name                     = "Basic"
    license_type                    = "BasePrice"
    max_size_gb                     = 2
    db_tag_name                     = "MSSQL_DB"

    app_nic_name                    = "app-nic"
    ip_config_name                  = "internal"

    key_path                        = "~/.ssh/id_rsa.pub"
    caching                         = "ReadWrite"
    storage_account_type            = "Standard_LRS"

    web_nic_name                    = "web-nic"
    ip_config                       = "external"

    storage_account_name            = "tfstrgacc"
    container_name                  = "tfstatecontainer"
    key                             = "terraform.tfstate"
}