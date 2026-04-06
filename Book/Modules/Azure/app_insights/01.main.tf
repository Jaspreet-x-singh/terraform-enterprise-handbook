resource "azurerm_log_analytics_workspace" "loganalytics" {
  name                       = var.workspace_name
  location                   = var.location
  resource_group_name        = var.resource_group_name
  sku                        = var.workspace_sku
  retention_in_days          = var.workspace_retention_days
  internet_ingestion_enabled = var.internet_ingestion_enabled
  internet_query_enabled     = var.internet_query_enabled
}

resource "azurerm_application_insights" "appinsights" {
  name                = var.app_insights_name
  location            = var.location
  resource_group_name = var.resource_group_name
  application_type    = var.app_insights_application_type
  workspace_id        = azurerm_log_analytics_workspace.loganalytics.id
}

resource "azurerm_monitor_diagnostic_setting" "diagnostic_setting" {
  count              = var.enabled && var.diagnostic_setting_enable ? 1 : 0
  name               = "${azurerm_application_insights.appinsights.name}-diagnostic-setting"
  target_resource_id = azurerm_application_insights.appinsights.id

  # At least one of these must be non-null
  storage_account_id             = var.storage_account_id

  enabled_metric {
    category = "AllMetrics"
  }

  enabled_log {
    category       = var.category
    category_group = "AllLogs"
  }

  lifecycle {
    ignore_changes = [log_analytics_destination_type]
  }
}
