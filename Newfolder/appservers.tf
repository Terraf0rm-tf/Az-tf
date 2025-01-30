data "azurerm_subnet" "app_subnet" {
    name                                = var.app_subnet
    resource_group_name                 = azurerm_resource_group.stark.name
    virtual_network_name                = azurerm_virtual_network.vnet.name

    depends_on                          = [ azurerm_subnet.subnets ]
}

resource "azurerm_network_interface" "app_nic" {
    name                                = local.app_nic_name
    location                            = azurerm_resource_group.stark.location
    resource_group_name                 = azurerm_resource_group.stark.name

    ip_configuration {
        name                            = local.ip_config_name
        subnet_id                       = data.azurerm_subnet.app_subnet.id
        private_ip_address_allocation   = var.public_ip_config.allocation_method
    }
    depends_on                          = [ data.azurerm_subnet.app_subnet ]    
}


resource "azurerm_network_interface_security_group_association" "Appnsg" {
    network_interface_id                = azurerm_network_interface.app_nic.id
    network_security_group_id           = azurerm_network_security_group.app_nsg.id

    depends_on                          = [ azurerm_network_interface.app_nic, azurerm_network_security_group.app_nsg ]     
}


resource "azurerm_linux_virtual_machine" "App_server" {
    count                               = length(var.appserver_names)
    name                                = element(var.appserver_names, count.index)
    resource_group_name                 = azurerm_resource_group.stark.name
    location                            = azurerm_resource_group.stark.location
    size                                = var.app_vm.size
    admin_username                      = var.app_vm.admin_username
    admin_password                      = var.app_vm.admin_password
    network_interface_ids               = [azurerm_network_interface.app_nic.id]
    disable_password_authentication     = false 

    # admin_ssh_key {
    #     username                      = var.app_vm.admin_username
    #     public_key                    = file(local.key_path)
    # }

    os_disk {
        name                            = "osdisk-${element(var.appserver_names, count.index)}-${count.index}"
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


resource "azurerm_subnet" "Azure_Bastion_Subnet" {
    name                                = "AzureBastionSubnet"
    resource_group_name                 = azurerm_resource_group.stark.name
    virtual_network_name                = azurerm_virtual_network.vnet.name
    address_prefixes                    = [ cidrsubnet(var.network_cidr[0], 8, 3) ]

    depends_on                          = [ azurerm_virtual_network.vnet ]
}

resource "azurerm_public_ip" "bastion_ip" {
    name                                = "bastionip"
    resource_group_name                 = azurerm_resource_group.stark.name
    location                            = azurerm_resource_group.stark.location
    allocation_method                   = "Static"
    sku                                 = "Standard" 

    tags                                = {
        environment                     = var.public_ip_config.Env_tags
    }
}

resource "azurerm_bastion_host" "App_Bastion" {
    name                                = "Sebastian"
    location                            = azurerm_resource_group.stark.location
    resource_group_name                 = azurerm_resource_group.stark.name

    ip_configuration {
        name                            = "ip-config"
        subnet_id                       = azurerm_subnet.Azure_Bastion_Subnet.id
        public_ip_address_id            = azurerm_public_ip.bastion_ip.id
    }
}