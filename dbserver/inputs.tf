variable "network_cidr" {
    type                            = list(string)
    default                         = [ "10.10.0.0/16" ]
}

variable "subnet_names" {
    type                            = list(string)
    default                         = [ "web", "app", "db" ]
}

variable "security_rule" {

    type                            = map
        default                     = {
        name                        = "ssh"
        ssh_priority                = 200
        web_priority                = 220
        app_priority                = 240        
        direction                   = "Inbound"
        access                      = "Allow"
        protocol                    = "Tcp"
        source_port_range           = "*"
        destination_port_range      = "*"
        ssh_port                    = "22"
        source_address_prefix       = "*"
        destination_address_prefix  = "*"
        http_port                   = "80"
        app_port                    = "8080"
    }
}

variable "private_endpoint_subnet" {
    type                            = string
    default                         = "db"
}