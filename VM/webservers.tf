data "azurerm_subnet" "web_subnet" {
    resource_group_name                 = azurerm_resource_group.stark.name
    virtual_network_name                = azurerm_virtual_network.vnet.name
    name                                = var.web_subnet

    depends_on                          = [ azurerm_subnet.subnets ]
}

resource "azurerm_public_ip" "webips" {
    count                               = var.public_ip.count
    name                                = var.public_ip.name
    resource_group_name                 = azurerm_resource_group.stark.name
    location                            = azurerm_resource_group.stark.location
    allocation_method                   = var.public_ip.allocation_method

    tags                                = {
        environment                     = var.public_ip.Env_tags
    }
}

resource "azurerm_network_interface" "web_nic" {
    count                               = var.public_ip.count
    name                                = local.web_nic_name
    location                            = azurerm_resource_group.stark.location
    resource_group_name                 = azurerm_resource_group.stark.name

    ip_configuration {
        name                            = local.ip_config_name
        subnet_id                       = data.azurerm_subnet.web_subnet.id
        public_ip_address_id            = "${length(azurerm_public_ip.webips.*.id) > 0 ? element(concat(azurerm_public_ip.webips.*.id, tolist([""])), count.index) : ""}"
        private_ip_address_allocation   = var.public_ip.allocation_method
    }
}


# resource "azurerm_network_interface_security_group_association" "Webnsg" {

#     network_interface_id                = azurerm_network_interface.web_nic.id
#     network_security_group_id           = azurerm_network_security_group.web_nsg.id
# }


resource "azurerm_linux_virtual_machine" "Web_server" {
    count                               = var.web_vm.count
    name                                = var.webserver_names[count.index]
    resource_group_name                 = azurerm_resource_group.stark.name
    location                            = azurerm_resource_group.stark.location
    size                                = var.web_vm.size
    admin_username                      = var.web_vm.admin_username
    admin_password                      = var.web_vm.admin_password
    network_interface_ids               = [ element(azurerm_network_interface.web_nic.*.id, count.index) ]
    disable_password_authentication     = false 

    # admin_ssh_key {
    #     username                      = var.web_vm.admin_username
    #     public_key                    = file(local.key_path)
    # }

    os_disk {
        caching                         = local.caching
        storage_account_type            = local.storage_account_type
    }

    source_image_reference {
        publisher                       = var.source_image_reference.publisher
        offer                           = var.source_image_reference.offer
        sku                             = var.source_image_reference.sku
        version                         = var.source_image_reference.version
    }
}