output "id" {
  description = "The ID of the Linux App Service."
  value       = azurerm_linux_web_app.app.id
}

output "name" {
  description = "The name of the Linux App Service."
  value       = azurerm_linux_web_app.app.name
}

output "default_hostname" {
  description = "The default hostname of the App Service."
  value       = azurerm_linux_web_app.app.default_hostname
}

output "identity_principal_id" {
  description = "The principal ID of the managed identity."
  value       = try(azurerm_linux_web_app.app.identity[0].principal_id, null)
}
