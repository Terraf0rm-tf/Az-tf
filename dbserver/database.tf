resource "azurerm_mssql_server" "sql_server" {
    name                            = local.sql_server_name
    resource_group_name             = azurerm_resource_group.stark.name
    location                        = azurerm_resource_group.stark.location
    version                         = local.sql_server_version
    administrator_login             = local.administrator_login
    administrator_login_password    = local.administrator_login_password

    depends_on                      = [ azurerm_subnet.subnets ]
}

resource "azurerm_mssql_database" "sql_db" {
    name                            = local.sql_db_name
    server_id                       = azurerm_mssql_server.sql_server.id
    sku_name                        = local.db_sku_name
    license_type                    = local.license_type
    max_size_gb                     = local.max_size_gb

    tags                            = {
        Name                        = local.db_tag_name
    }

    depends_on = [ azurerm_mssql_server.sql_server ]
}


# data "azurerm_subnet" "dbsubnet" {
#     resource_group_name             = azurerm_resource_group.stark.name
#     virtual_network_name            = azurerm_virtual_network.vnet.name
#     name                            = var.private_endpoint_subnet

#     depends_on = [ azurerm_subnet.subnets, azurerm_mssql_database.sql_db ]
# }

# resource "azurerm_private_endpoint" "dbendpoint" {
#     name                            = "db-endpoint"
#     location                        = azurerm_resource_group.stark.location
#     resource_group_name             = azurerm_resource_group.stark.name
#     subnet_id                       = data.azurerm_subnet.dbsubnet.id

#   private_service_connection {
#     name                            = "db-privateconnection"
#     private_connection_resource_id  = azurerm_private_link_service.example.id
#     is_manual_connection            = false
#   }
# }