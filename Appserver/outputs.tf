output "subnet_test" {
    value       = azurerm_subnet.all_subnets
}

output "public_ip_address" {
    value       = "${azurerm_public_ip.web_ip.*.ip_address}"
    
    depends_on = [ azurerm_public_ip.web_ip ]
}

