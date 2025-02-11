# output "public_ip" {
#   value = azurerm_public_ip.webip.ip_addresses
# }

# data "http" "my_public_ip" {
#   url = "https://ifconfig.co/json"
#   request_headers = {
#     Accept = "application/json"
#   }
# }

# locals {
#   ifconfig_co_json = jsondecode(data.http.my_public_ip.body)
# }

# output "my_ip_addr" {
#   value = local.ifconfig_co_json.ip
# }

data "http" "ip" {
  url = "https://ifconfig.me/ip"
}

output "ip" {
  value = data.http.ip.response_body
}