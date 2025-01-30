prefix   = "my"
location = "East US"

vm_instances = {
  "vm1" = {
    vm_size            = "Standard_DS1_v2"
    os_image_publisher = "Canonical"
    os_image_offer     = "UbuntuServer"
    os_image_sku       = "16.04-LTS"
    os_image_version   = "latest"
  },
  "vm2" = {
    vm_size            = "Standard_DS2_v2"
    os_image_publisher = "Canonical"
    os_image_offer     = "UbuntuServer"
    os_image_sku       = "18.04-LTS"
    os_image_version   = "latest"
  }
}
