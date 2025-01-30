
resource "azurerm_resource_group" "stark" {
  name                              = local.resource_group_name
  location                          = local.resource_group_location
}

 resource "azurerm_virtual_network" "vnet" {
  name                              = "azvnet"
  address_space                     = var.network_cidr
  location                          = azurerm_resource_group.stark.location
  resource_group_name               = azurerm_resource_group.stark.name

  depends_on                        = [ azurerm_resource_group.stark ]
}

 resource "azurerm_subnet" "web_subnet" {
    count                           = length(var.nic_names)
    name                            = "web${count.index}"
    resource_group_name             = azurerm_resource_group.stark.name
    virtual_network_name            = azurerm_virtual_network.vnet.name
    address_prefixes                = [ cidrsubnet(var.network_cidr[0], 8, count.index) ]

    depends_on                      = [ azurerm_virtual_network.vnet ]
}


 resource "azurerm_public_ip" "web_ip" {
    count                           = length(var.public_ip)
    name                            = element(var.public_ip, count.index)
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
      subnet_id                     = "${element(azurerm_subnet.web_subnet.*.id, count.index)}"
      private_ip_address_allocation = var.public_ip_config.allocation_method
      public_ip_address_id          = "${azurerm_public_ip.web_ip[count.index].id}"
    }
    depends_on                      = [ azurerm_subnet.web_subnet ]
}

resource "azurerm_network_security_group" "web_nsg" {
  name                              = "webnsg"
  location                          = azurerm_resource_group.stark.location
  resource_group_name               = azurerm_resource_group.stark.name

  security_rule {
    name                            = "openssh"
    priority                        = var.security_rule.ssh_priority
    direction                       = var.security_rule.direction
    access                          = var.security_rule.access
    protocol                        = var.security_rule.protocol
    source_port_range               = var.security_rule.source_port_range
    destination_port_range          = var.security_rule.ssh_port
    source_address_prefix           = var.security_rule.source_address_prefix
    destination_address_prefix      = var.security_rule.source_address_prefix
  }
  
  security_rule {
    name                            = "openhttp"
    priority                        = var.security_rule.web_priority
    direction                       = var.security_rule.direction
    access                          = var.security_rule.access
    protocol                        = var.security_rule.protocol
    source_port_range               = var.security_rule.source_port_range
    destination_port_range          = var.security_rule.http_port
    source_address_prefix           = var.security_rule.source_address_prefix
    destination_address_prefix      = var.security_rule.destination_address_prefix
  }
  depends_on                        = [ azurerm_subnet.web_subnet ]
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
    size                            = var.web_vm.size
    admin_username                  = var.web_vm.admin_username
    admin_password                  = var.web_vm.admin_password
    disable_password_authentication = false

    source_image_reference {
      publisher                     = var.source_image_reference.publisher
      offer                         = var.source_image_reference.offer
      sku                           = var.source_image_reference.sku
      version                       = var.source_image_reference.version
    }

    os_disk {
      name                          = "myosdisk${count.index}"
      caching                       = local.caching
      storage_account_type          = local.storage_account_type
    }
    tags                            = {
        environment                 = "staging${count.index}"
    }
}

resource "null_resource" "wait_for_ip" {
    provisioner "local-exec" {
       command = "sleep 90"  # Adjust the sleep time as needed
    }
    depends_on = [ azurerm_linux_virtual_machine.az_vm ]
}
