output "Default-Domain" {
    value       = azurerm_linux_web_app.app-service.*.default_hostname
}

output "Ob-Ip-Addresses" {
    value       = azurerm_linux_web_app.app-service.*.outbound_ip_address_list
}