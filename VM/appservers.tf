data "azurerm_subnet" "app_subnet" {
    resource_group_name                 = azurerm_resource_group.stark.name
    virtual_network_name                = azurerm_virtual_network.vnet.name
    name                                = var.app_subnet

    depends_on                          = [ azurerm_subnet.subnets ]
}

resource "azurerm_network_interface" "app_nic" {
    name                                = local.app_nic_name
    location                            = azurerm_resource_group.stark.location
    resource_group_name                 = azurerm_resource_group.stark.name

    ip_configuration {
        name                            = local.ip_config_name
        subnet_id                       = data.azurerm_subnet.app_subnet.id
        private_ip_address_allocation   = var.public_ip.allocation_method
    }
}


resource "azurerm_network_interface_security_group_association" "Appnsg" {
    network_interface_id                = azurerm_network_interface.app_nic.id
    network_security_group_id           = azurerm_network_security_group.app_nsg.id
}


resource "azurerm_linux_virtual_machine" "App_server" {
    count                               = var.app_vm.count
    name                                = var.appserver_names[count.index]
    resource_group_name                 = azurerm_resource_group.stark.name
    location                            = azurerm_resource_group.stark.location
    size                                = var.app_vm.size
    admin_username                      = var.app_vm.admin_username
    admin_password                      = var.app_vm.admin_password
    network_interface_ids               = [ azurerm_network_interface.app_nic.id ]
    disable_password_authentication     = false 

    # admin_ssh_key {
    #     username                      = var.app_vm.admin_username
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