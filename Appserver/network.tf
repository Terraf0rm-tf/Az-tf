# data "azurerm_resource_group" "rg" {
#     name                            = var.resource_group_name
#     #environment                    = var.environment
# }

resource "azurerm_resource_group" "stark" {
  name                                = var.resource_group_name
  location                            = local.resource_group_location
}

resource "azurerm_virtual_network" "vnet" {
  name                                = "azvnet"
  address_space                       = var.network_cidr
  location                            = azurerm_resource_group.stark.location
  resource_group_name                 = azurerm_resource_group.stark.name

  depends_on                          = [ azurerm_resource_group.stark ]
}

resource "azurerm_subnet" "all_subnets" {
  count                               = length(var.subnet_names)
  name                                = "${element(var.subnet_names, count.index)}"
  resource_group_name                 = azurerm_resource_group.stark.name
  virtual_network_name                = azurerm_virtual_network.vnet.name
  address_prefixes                    = [ cidrsubnet(var.network_cidr[0], 8, count.index) ]

  depends_on                          = [ azurerm_virtual_network.vnet ]
}

resource "azurerm_network_security_group" "app_nsg" {
  name                                = "appnsg"
  location                            = azurerm_resource_group.stark.location
  resource_group_name                 = azurerm_resource_group.stark.name

  security_rule {
    name                              = "withinnetwork"
    priority                          = var.security_rule.app_priority
    direction                         = var.security_rule.direction
    access                            = var.security_rule.access
    protocol                          = var.security_rule.protocol
    source_port_range                 = var.security_rule.source_port_range
    destination_port_range            = var.security_rule.destination_port_range
    source_address_prefix             = var.network_cidr[0]
    destination_address_prefix        = var.security_rule.destination_address_prefix
  }
  depends_on                          = [ azurerm_virtual_network.vnet ]
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
  depends_on                        = [ azurerm_subnet.all_subnets ]
}
