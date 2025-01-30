variable "prefix" {
  description = "Prefix to add to all resources"
  type        = string
  default     = "my"
}

variable "location" {
  description = "Azure region where resources will be created"
  type        = string
  default     = "East US"
}

variable "vm_instances" {
  description = "Map of instance names and configurations for VMs"
  type = map(object({
    vm_size            = string
    os_image_publisher = string
    os_image_offer     = string
    os_image_sku       = string
    os_image_version   = string
  }))
  default = {
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
}
