resource "azurerm_linux_web_app" "app" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  service_plan_id     = var.app_service_plan_id

  https_only              = var.https_only
  client_affinity_enabled = var.client_affinity_enabled

  tags = var.tags

  # -------------------------
  # Identity
  # -------------------------
  identity {
    type = var.identity_type
    identity_ids = (
      var.identity_type == "UserAssigned" ||
      var.identity_type == "SystemAssigned, UserAssigned"
    ) ? var.identity_ids : null
  }

  # -------------------------
  # Site Config
  # -------------------------
  site_config {
    always_on                         = var.site_config.always_on
    ftps_state                        = var.site_config.ftps_state
    minimum_tls_version               = var.site_config.minimum_tls_version
    http2_enabled                     = var.site_config.http2_enabled
    health_check_path                 = var.site_config.health_check_path
    health_check_eviction_time_in_min = var.site_config.health_check_eviction_time_in_min

    dynamic "application_stack" {
      for_each = var.site_config.python_version != null || var.site_config.node_version != null || var.site_config.dotnet_version != null || var.site_config.java_version != null ? [1] : []

      content {
        python_version = var.site_config.python_version
        node_version   = var.site_config.node_version
        dotnet_version = var.site_config.dotnet_version
        java_version   = var.site_config.java_version
      }
    }
  }

  # -------------------------
  # App Settings
  # -------------------------
  app_settings = var.app_settings

  # -------------------------
  # Logs
  # -------------------------
  dynamic "logs" {
    for_each = var.logs_enabled ? [1] : []

    content {
      detailed_error_messages = var.logs.detailed_error_messages
      failed_request_tracing  = var.logs.failed_request_tracing

      dynamic "http_logs" {
        for_each = var.logs.http_logs_enabled ? [1] : []

        content {
          file_system {
            retention_in_days = var.logs.http_logs.retention_in_days
            retention_in_mb   = var.logs.http_logs.retention_in_mb
          }
        }
      }
    }
  }

  # -------------------------
  # Connection Strings
  # -------------------------
  dynamic "connection_string" {
    for_each = var.connection_strings
    content {
      name  = connection_string.value.name
      type  = connection_string.value.type
      value = connection_string.value.value
    }
  }

  # -------------------------
  # Timeouts
  # -------------------------
  timeouts {
    create = var.timeouts.create
    update = var.timeouts.update
    delete = var.timeouts.delete
  }
}
