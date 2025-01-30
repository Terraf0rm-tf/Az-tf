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

variable "app_subnet" {
    type                            = string
    default                         = "app"
}

variable "web_subnet" {
    type                            = string
    default                         = "web"
}


variable "app_vm" {

    type                            = map
        default                     = {
            count                   = 2
            size                    = "Standard_B1s"
            admin_username          = "aegon"
            admin_password          = "Targaryen@786"
    }
}

variable "source_image_reference" {

    type                            = map
        default                     = {
            publisher               = "Canonical"
            offer                   = "0001-com-ubuntu-server-focal"
            sku                     = "20_04-lts"
            version                 = "latest"
    }
}

variable "public_ip" {

    type                            = map
        default                     = {
            count                   = 2
            name                    = "WebPublicIp"
            allocation_method       = "Dynamic"
            Env_tags                = "Webs"
    }
}

variable "web_vm" {

    type                            = map
        default                     = {
            count                   = 2
            size                    = "Standard_B1s"
            admin_username          = "aegon"
            admin_password          = "Targaryen@786"
    }
}


variable "appserver_names" {
    type                            = list(string)
    default                         = [ "appserver1", "appserver2" ]
}

variable "webserver_names" {
    type                            = list(string)
    default                         = [ "webserver1", "webserver2" ]
}