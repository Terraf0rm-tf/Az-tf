variable "network_cidr" {
    type        = list(string)
    default     = [ "10.10.0.0/16" ]
}

variable "subnet_names" {
    type        = list(string)
    default     = [ "web1", "web2", "app1", "app2", "db1", "db2" ]
}

variable "security_rule" {

    type                           = map
        default                    = {
        name                       = "ssh"
        ssh_priority               = 200
        web_priority               = 230
        app_priority               = 250        
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "*"
        ssh_port                   = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
        http_port                  = "80"
        app_port                   = "8080"
    }

}


# variable "web_security_rule" {
#     type                           = map
#         default                    = {
#         name                       = "http"
#         priority                   = 230
#         direction                  = "Inbound"
#         access                     = "Allow"
#         protocol                   = "tcp"
#         source_port_range          = "*"
#         destination_port_range     = "80"
#         source_address_prefix      = "*"
#         destination_address_prefix = "*"
#     }
# }