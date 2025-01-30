variable "network_cidr" {
    type                            = list(string)
    default                         = [ "10.10.0.0/16" ]
}

variable "subnet_names" {
    type                            = list(string)
    default                         = [ "web1", "web2", "app1", "app2" ]
}

variable "nic_names" {
    type                            = list(string)
    default                         = [ "appnic1", "appnic2" ] 
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
            size                    = "Standard_B1s"
            admin_username          = "aegon"
            admin_password          = "Targaryen@786"
    }
}

variable "public_ip_config" {
    type                            = map
        default                     = {
            allocation_method       = "Dynamic"
            Env_tags                = "Webs"
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

variable "publicip" {
    type                            = list(string)
    default                         = [ "web_ip1", "web_ip2" ]
}

variable "resource_group_name" {
    type                            = string
    default                         = "From_TF"
}