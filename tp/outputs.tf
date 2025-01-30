# output "public_ip" {
#   value = format("http://%s", azurerm_public_ip.bastion_ip.ip_address)
# }

output "public_ip_address" {
    value       = "${azurerm_public_ip.web_ip.*.ip_address}"

    depends_on = [ azurerm_public_ip.bastion_ip ]
}