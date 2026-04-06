output "id" {
  description = "The ID of the App Service Plan."
  value       = azurerm_service_plan.asp.id
}

output "app_service_plan_name" {
  description = "The name of the App Service Plan."
  value       = azurerm_service_plan.asp.name
}

output "location" {
  description = "The location of the App Service Plan."
  value       = azurerm_service_plan.asp.location
}

output "sku_name" {
  description = "The SKU of the App Service Plan."
  value       = azurerm_service_plan.asp.sku_name
}

output "os_type" {
  description = "The OS type of the App Service Plan."
  value       = azurerm_service_plan.asp.os_type
}
