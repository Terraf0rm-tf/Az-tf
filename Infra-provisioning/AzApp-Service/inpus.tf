variable "rg_name" {
    type    = string
    default = "From_YT"
}

variable "location" {
    type    = string
    default = "Central India"
}

variable "service-plan" {
    type                          = map
        default                   = {
            name                  = "simple-service-plan"
            os_type               = "Linux"
            sku_name              = "S1"
            environment           = "dev"
    }
}

variable "linux_web_app" {
    type                          = map
        default                   = {
            name                  = "my-web-app-svc-2024"
    }    
}