# Find the subnet
data "azurerm_subnet" "app_subnet" {
  name                                = "${var.app_subnet}"
  resource_group_name                 = "${azurerm_resource_group.stark.name}"
  virtual_network_name                = "${azurerm_virtual_network.vnet.name}"

  depends_on                          = [ azurerm_subnet.all_subnets ]
}

resource "azurerm_network_interface" "app_nic" {
  count                               = length(var.nic_names)
  name                                = local.app_nic_name
  location                            = azurerm_resource_group.stark.location
  resource_group_name                 = azurerm_resource_group.stark.name

  ip_configuration {
    name                              = local.ip_config_name
    subnet_id                         = "${element(data.azurerm_subnet.app_subnet.*.id, count.index)}"
    private_ip_address_allocation     = var.public_ip_config.allocation_method
  }
  depends_on                          = [ azurerm_subnet.all_subnets ]    
}

resource "azurerm_network_interface_security_group_association" "Appnsg" {
    count                             = length(var.nic_names)
    network_interface_id              = element(azurerm_network_interface.app_nic.*.id, count.index)
    network_security_group_id         = azurerm_network_security_group.app_nsg.id

    depends_on                        = [ azurerm_network_interface.app_nic, azurerm_network_security_group.app_nsg ]     
}

resource "azurerm_linux_virtual_machine" "App_server" {
    count                             = length(var.nic_names)
    name                              = "appserver${count.index}"
    location                          = azurerm_resource_group.stark.location
    resource_group_name               = azurerm_resource_group.stark.name
    network_interface_ids             = [element(azurerm_network_interface.app_nic.*.id, count.index)]
    size                              = var.app_vm.size
    admin_username                    = var.app_vm.admin_username
    admin_password                    = var.app_vm.admin_password

    disable_password_authentication   = false 

    # admin_ssh_key {
    #     username                    = var.app_vm.admin_username
    #     public_key                  = file(local.key_path)
    # }

    os_disk {
        name                          = "apposdisk-${count.index}"
        caching                       = local.caching
        storage_account_type          = local.storage_account_type
    }

    source_image_reference {
        publisher                     = var.source_image_reference.publisher
        offer                         = var.source_image_reference.offer
        sku                           = var.source_image_reference.sku
        version                       = var.source_image_reference.version
    }
}

