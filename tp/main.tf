
 resource "azurerm_resource_group" "test" {
   name     = local.resource_group_name
   location = local.resource_group_location
 }

 resource "azurerm_virtual_network" "test" {
   name                = "acctvn"
   address_space       = ["10.0.0.0/16"]
   location            = azurerm_resource_group.test.location
   resource_group_name = azurerm_resource_group.test.name
 }

 resource "azurerm_subnet" "test" {
   name                 = "acctsub"
   resource_group_name  = azurerm_resource_group.test.name
   virtual_network_name = azurerm_virtual_network.test.name
   address_prefixes     = ["10.0.1.0/24"]
 }

resource "azurerm_network_interface" "test" {
    count               = 2
    name                = var.nic_names[count.index]
    location            = azurerm_resource_group.test.location
    resource_group_name = azurerm_resource_group.test.name

    ip_configuration {
        name                          = "testConfiguration"
        subnet_id                     = azurerm_subnet.test.id
        private_ip_address_allocation = "Dynamic"
   }
 }


 resource "azurerm_linux_virtual_machine" "test" {
    count                 = 2
    name                  = "acctvm${count.index}"
    location              = azurerm_resource_group.test.location
    resource_group_name   = azurerm_resource_group.test.name
    network_interface_ids = [element(azurerm_network_interface.test.*.id, count.index)]
    size                  = "Standard_B1s"
    admin_username        = "testadmin"
    admin_password        = "Password1234!"
    disable_password_authentication = false

   source_image_reference {
     publisher = "Canonical"
     offer     = "0001-com-ubuntu-server-focal"
     sku       = "20_04-lts"
     version   = "latest"
   }

   os_disk {
     name                   = "myosdisk${count.index}"
     caching                = "ReadWrite"
     storage_account_type   = "Standard_LRS"
   }

   tags = {
     environment = "staging"
   }
 }

 resource "azurerm_subnet" "Azure_Bastion_Subnet" {
    name                                = "AzureBastionSubnet"
    resource_group_name                 = azurerm_resource_group.test.name
    virtual_network_name                = azurerm_virtual_network.test.name
    address_prefixes                    = [ "10.0.3.0/24" ]

    depends_on                          = [ azurerm_virtual_network.test ]
}

resource "azurerm_public_ip" "bastion_ip" {
    name                                = "bastionip"
    resource_group_name                 = azurerm_resource_group.test.name
    location                            = azurerm_resource_group.test.location
    allocation_method                   = "Static"
    sku                                 = "Standard" 

    tags                                = {
        environment                     = "Webs"
    }
}

resource "azurerm_bastion_host" "App_Bastion" {
    name                                = "Sebastian"
    location                            = azurerm_resource_group.test.location
    resource_group_name                 = azurerm_resource_group.test.name

    ip_configuration {
        name                            = "ip-config"
        subnet_id                       = azurerm_subnet.Azure_Bastion_Subnet.id
        public_ip_address_id            = azurerm_public_ip.bastion_ip.id
    }
}
