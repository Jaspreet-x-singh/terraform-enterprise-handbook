output "log_analytics_workspace_id" {
  description = "The ID of the Log Analytics Workspace."
  value       = azurerm_log_analytics_workspace.loganalytics.id
}

output "log_analytics_workspace_name" {
  description = "The name of the Log Analytics Workspace."
  value       = azurerm_log_analytics_workspace.loganalytics.name
}

output "application_insights_id" {
  description = "The ID of the Application Insights instance."
  value       = azurerm_application_insights.appinsights.id
}

output "application_insights_name" {
  description = "The name of the Application Insights instance."
  value       = azurerm_application_insights.appinsights.name
}

output "application_insights_instrumentation_key" {
  description = "Instrumentation Key for Application Insights."
  value       = azurerm_application_insights.appinsights.instrumentation_key
}

output "application_insights_connection_string" {
  description = "Connection string for Application Insights."
  value       = azurerm_application_insights.appinsights.connection_string
  sensitive   = true
}

output "diagnostic_setting_id" {
  description = "The ID of the diagnostic setting (if enabled)."
  value       = try(azurerm_monitor_diagnostic_setting.diagnostic_setting[0].id, null)
}
