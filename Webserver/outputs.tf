output "subnet_test" {
    value       = azurerm_subnet.web_subnet
}

data "azurerm_public_ip" "web_ip" {
  count               = length(var.public_ip)
  name                = element(azurerm_public_ip.web_ip.*.name, count.index)
  resource_group_name = azurerm_resource_group.stark.name
}

output "public_ip_addresses" {
    value       = [ for ip in azurerm_public_ip.web_ip : ip.ip_address ]

    # depends_on  = [ null_resource.wait_for_ip ]
}

output "debug_public_ip_0" {
  value = azurerm_public_ip.web_ip[0].ip_address
}

output "debug_public_ip_1" {
  value = azurerm_public_ip.web_ip[1].ip_address
}