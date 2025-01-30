# Resource group
resource "azurerm_resource_group" "dev-rg" {
     name                = var.rg_name
     location            = var.location
}

# App Service plan
resource "azurerm_service_plan" "service-plan" {
     name                = var.service-plan.name
     location            = azurerm_resource_group.dev-rg.location
     resource_group_name = azurerm_resource_group.dev-rg.name
     os_type             = var.service-plan.os_type
     sku_name            = var.service-plan.sku_name

    tags = { Env = var.service-plan.environment }
}

# JAVA App Service
resource "azurerm_linux_web_app" "app-service" {
     name                = var.linux_web_app.name
     location            = azurerm_resource_group.dev-rg.location
     resource_group_name = azurerm_resource_group.dev-rg.name
     service_plan_id     = azurerm_service_plan.service-plan.id
    
    site_config {
    }

    tags = { Env = var.service-plan.environment }
}