data "azurerm_subnet" "web_subnet" {
    name                                = "${var.web_subnet}"
    resource_group_name                 = "${azurerm_resource_group.stark.name}"
    virtual_network_name                = "${azurerm_virtual_network.vnet.name}"

    depends_on                          = [ azurerm_subnet.all_subnets ]
}

#  resource "azurerm_subnet" "web_subnet" {
#     count                           = length(var.nic_names)    
#     name                            = "web${count.index}"
#     resource_group_name             = azurerm_resource_group.stark.name
#     virtual_network_name            = azurerm_virtual_network.vnet.name
#     address_prefixes                = [ cidrsubnet(var.network_cidr[0], 8, count.index) ]

#     depends_on                      = [ azurerm_virtual_network.vnet ]
# }

 resource "azurerm_public_ip" "web_ip" {
    count                           = length(var.nic_names)
    name                            = element(var.publicip, count.index)
    resource_group_name             = azurerm_resource_group.stark.name
    location                        = azurerm_resource_group.stark.location
    allocation_method               = var.public_ip_config.allocation_method

    tags                            = {
        environment                 = var.public_ip_config.Env_tags
    }
    depends_on                      = [ azurerm_resource_group.stark ]
}

 resource "azurerm_network_interface" "web_nic" {
    count                           = length(var.nic_names)
    name                            = var.nic_names[count.index]
    location                        = azurerm_resource_group.stark.location
    resource_group_name             = azurerm_resource_group.stark.name

    ip_configuration {
        name                          = "testConfiguration" 
        subnet_id                     = "${element(data.azurerm_subnet.web_subnet.*.id, count.index)}"
        private_ip_address_allocation = var.public_ip_config.allocation_method
        public_ip_address_id          = "${azurerm_public_ip.web_ip[count.index].id}"
    }
    depends_on                        = [ data.azurerm_subnet.web_subnet ]
}


 resource "azurerm_network_interface_security_group_association" "association" {
    count                           = length(var.nic_names)
    network_interface_id            = element(azurerm_network_interface.web_nic.*.id, count.index)
    network_security_group_id       = azurerm_network_security_group.web_nsg.id
}


 resource "azurerm_linux_virtual_machine" "az_vm" {
    count                           = length(var.nic_names)
    name                            = "webserver${count.index}"
    location                        = azurerm_resource_group.stark.location
    resource_group_name             = azurerm_resource_group.stark.name
    network_interface_ids           = [element(azurerm_network_interface.web_nic.*.id, count.index)]
    size                            = var.app_vm.size
    admin_username                  = var.app_vm.admin_username
    admin_password                  = var.app_vm.admin_password
    disable_password_authentication = false

    source_image_reference {
      publisher                     = var.source_image_reference.publisher
      offer                         = var.source_image_reference.offer
      sku                           = var.source_image_reference.sku
      version                       = var.source_image_reference.version
    }

    os_disk {
      name                          = "webdisk${count.index}"
      caching                       = local.caching
      storage_account_type          = local.storage_account_type
    }
    tags                            = {
        environment                 = "staging${count.index}"
    }
}
