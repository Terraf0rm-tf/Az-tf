locals {

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

    resource_group_name             = "From_YT"
    storage_account_name            = "tfstorgacc"
    container_name                  = "tfwebappcontainer"
    key                             = "terraform.tfstate"

}