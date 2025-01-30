variable "Infra" {
  type = map(string)
  default = {
    rg_name   = "universe"
    vnet_name = "azVNet"
    location  = "Central India"
  }
}

variable "tags" {
  type        = map(string)
  description = "Tags used for the deployment"
  default = {
    "Environment" = "Testing"
    "Owner"       = "Ms"
  }
}

variable "network_cidr" {
  type    = list(string)
  default = ["10.10.0.0/16"]
}


# variable "subnets" {
#     type = map(list(object({
#         name               = string
#         subnets = object({
#             name            = string
#             address_prefixes = list(string)
#         })
#     })))
#     default = {
#         subnets = "subnet_1"({
#             name             = "Web"
#             address_prefixes = ["10.10.1.0/24"]
#         })
#         subnets = "subnet_2"({
#             name             = "App"
#             address_prefixes = ["10.10.2.0/24"]
#         })
#         subnets = "subnet_3"({
#             name             = "db"
#             address_prefixes = ["10.10.3.0/24"]
#         })
#     }
# }


variable "pub_ip" {
  type = map(any)
  default = {
    name              = "ipConfig"
    allocation_method = "Dynamic"
  }
}


variable "vm_map" {
  type = map(object({
    name           = string
    size           = string
    admin_password = string
    subnet_name    = string
  }))
  default = {
    "vm1" = {
      name           = "vm1"
      size           = "Standard_B1s"
      admin_password = "Targaryen@786"
      subnet_name    = "Web"
    }
    "vm2" = {
      name           = "vm2"
      size           = "Standard_B2s"
      admin_password = "Targaryen@789"
      subnet_name    = "App"
    }
  }
}


variable "vm_admin" {
  type    = string
  default = "aegon"
}

variable "source_image_reference" {
  type = map(any)
  default = {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }
}

variable "os_disk" {
  type = map(any)
  default = {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
}

variable "subnet_names" {
  type    = list(string)
  default = ["Web", "App"]
}

