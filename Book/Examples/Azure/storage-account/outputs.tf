output "name" {
  description = "The name of the Storage Account."
  value       = module.app_storage_account.name
}

output "primary_endpoint" {
  description = "The primary blob endpoint of the Storage Account."
  value       = module.app_storage_account.primary_blob_endpoint
}

output "primary_connection_string" {
  description = "The primary connection string of the Storage Account."
  value       = module.app_storage_account.primary_connection_string
  sensitive   = true
}

output "account_tier" {
  description = "The tier of the Storage Account."
  value       = module.app_storage_account.account_tier
}

output "account_replication_type" {
  description = "The replication type of the Storage Account."
  value       = module.app_storage_account.account_replication_type
}

output "https_traffic_only_enabled" {
  description = "Whether HTTPS-only traffic is enabled."
  value       = module.app_storage_account.https_traffic_only_enabled
}

output "account_kind" {
  description = "The kind of the Storage Account."
  value       = module.app_storage_account.account_kind
}

output "containers" {
  description = "Created containers."
  value       = module.app_storage_account.containers
}
