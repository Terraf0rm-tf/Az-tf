provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "main" {
  name     = "${var.prefix}-resource-group"
  location = var.location
}

resource "azurerm_virtual_network" "main" {
  name                = "${var.prefix}-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  depends_on          = [ azurerm_resource_group.main ]
}

resource "azurerm_subnet" "public" {
  for_each             = var.vm_instances
  name                 = "${var.prefix}-public-subnet-${each.key}"
  address_prefixes     = ["10.0.${each.key}.0/24"]
  virtual_network_name = azurerm_virtual_network.main.name
  resource_group_name  = azurerm_resource_group.main.name

  depends_on           = [ azurerm_virtual_network.main ]
}

resource "azurerm_subnet" "private" {
  for_each             = var.vm_instances
  name                 = "${var.prefix}-private-subnet-${each.key}"
  address_prefixes     = ["10.1.${each.key}.0/24"]
  virtual_network_name = azurerm_virtual_network.main.name
  resource_group_name  = azurerm_resource_group.main.name

  depends_on           = [ azurerm_virtual_network.main ]
}

resource "azurerm_network_interface" "main" {
  for_each            = var.vm_instances
  name                = "${var.prefix}-nic-${each.key}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "${var.prefix}-nic-ipconfig-${each.key}"
    subnet_id                     = azurerm_subnet.public[each.key].id
    private_ip_address_allocation = "Dynamic"
  }

  depends_on = [ azurerm_resource_group.main ]
}

resource "azurerm_virtual_machine" "main" {
  for_each              = var.vm_instances
  name                  = "${var.prefix}-vm-${each.key}"
  location              = azurerm_resource_group.main.location
  resource_group_name   = azurerm_resource_group.main.name
  network_interface_ids = [azurerm_network_interface.main[each.key].id]

  vm_size = each.value.vm_size

  storage_image_reference {
    publisher = each.value.os_image_publisher
    offer     = each.value.os_image_offer
    sku       = each.value.os_image_sku
    version   = each.value.os_image_version
  }

  storage_os_disk {
    name                 = "${var.prefix}-osdisk-${each.key}"
    caching              = "ReadWrite"
    create_option        = "FromImage"
    managed_disk_type    = "Standard_LRS"
  }

  depends_on = [ azurerm_network_interface.main ]
}

output "public_ips" {
  value = azurerm_network_interface.main.*.ip_configuration[0].public_ip_address
}

output "private_ips" {
  value = azurerm_network_interface.main.*.private_ip_address
}
