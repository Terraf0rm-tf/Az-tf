
resource "azurerm_resource_group" "vnet_rg" {
  name     = var.Infra.rg_name
  location = var.Infra.location
  tags     = var.tags
}

resource "azurerm_virtual_network" "vnetwork" {
  name                = var.Infra.vnet_name
  address_space       = var.network_cidr
  location            = azurerm_resource_group.vnet_rg.location
  resource_group_name = azurerm_resource_group.vnet_rg.name
  tags                = var.tags
}

resource "azurerm_subnet" "subnets" {
  count                = length(var.subnet_names)
  name                 = var.subnet_names[count.index]
  resource_group_name  = azurerm_resource_group.vnet_rg.name
  virtual_network_name = azurerm_virtual_network.vnetwork.name
  address_prefixes     = [cidrsubnet(var.network_cidr[0], 8, count.index)]
}

resource "azurerm_public_ip" "public_ip" {
  for_each            = var.vm_map
  name                = "${each.key}-ip"
  location            = azurerm_resource_group.vnet_rg.location
  resource_group_name = azurerm_resource_group.vnet_rg.name
  allocation_method   = var.pub_ip.allocation_method
  tags                = var.tags
}

resource "azurerm_network_interface" "vm_nic" {
  for_each            = var.vm_map
  name                = "${each.key}-nic"
  location            = azurerm_resource_group.vnet_rg.location
  resource_group_name = azurerm_resource_group.vnet_rg.name

  ip_configuration {
    name                          = var.pub_ip.name
    subnet_id                     = "azurerm_subnet.subnets.*.id"
    private_ip_address_allocation = var.pub_ip.allocation_method
    public_ip_address_id          = azurerm_public_ip.public_ip[each.key].id
  }
  depends_on = [azurerm_subnet.subnets]
}

resource "azurerm_linux_virtual_machine" "az_vm" {
  for_each                        = var.vm_map
  name                            = each.key
  location                        = azurerm_resource_group.vnet_rg.location
  resource_group_name             = azurerm_resource_group.vnet_rg.name
  network_interface_ids           = [azurerm_network_interface.vm_nic[each.key].id]
  size                            = each.value.size
  admin_username                  = var.vm_admin
  admin_password                  = each.value.admin_password
  disable_password_authentication = false

  source_image_reference {
    publisher = var.source_image_reference.publisher
    offer     = var.source_image_reference.offer
    sku       = var.source_image_reference.sku
    version   = var.source_image_reference.version
  }

  os_disk {
    name                 = "${each.key}-os_disk"
    caching              = var.os_disk.caching
    storage_account_type = var.os_disk.storage_account_type
  }
  tags = var.tags
}
