data "azurerm_linux_web_app" "app-service" {
    name                = "${var.linux_web_app.name}"
    resource_group_name = "${azurerm_resource_group.dev-rg.name}"
}

output "Default-Domain" {
    value       = azurerm_linux_web_app.app-service.*.default_hostname
}

output "Ob-Ip-Addresses" {
    value       = azurerm_linux_web_app.app-service.*.outbound_ip_address_list
}