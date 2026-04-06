output "id" {
  description = "The ID of the Storage Account."
  value       = azurerm_storage_account.storage.id
}

output "name" {
  description = "The name of the Storage Account."
  value       = azurerm_storage_account.storage.name
}

output "primary_blob_endpoint" {
  description = "The primary Blob endpoint for the Storage Account."
  value       = azurerm_storage_account.storage.primary_blob_endpoint
}

output "primary_connection_string" {
  description = "The primary connection string for the Storage Account."
  value       = azurerm_storage_account.storage.primary_connection_string
  sensitive   = true
}

output "containers" {
  description = "Map of created storage containers."
  value       = azurerm_storage_container.containers
}
output "account_tier" {
  description = "The tier of the Storage Account."
  value       = azurerm_storage_account.storage.account_tier
}

output "account_replication_type" {
  description = "The replication type of the Storage Account."
  value       = azurerm_storage_account.storage.account_replication_type
}

output "https_traffic_only_enabled" {
  description = "Whether HTTPS-only traffic is enabled."
  value       = azurerm_storage_account.storage.https_traffic_only_enabled
}

output "account_kind" {
  description = "The kind of the Storage Account."
  value       = azurerm_storage_account.storage.account_kind
}
