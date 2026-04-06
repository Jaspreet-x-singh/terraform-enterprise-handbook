variable "name" {
  description = "The name of the Linux App Service."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the Resource Group."
  type        = string
}

variable "location" {
  description = "Azure region where the App Service will be deployed."
  type        = string
}

variable "app_service_plan_id" {
  description = "The ID of the existing App Service Plan."
  type        = string
}

variable "https_only" {
  description = "Force HTTPS only."
  type        = bool
  default     = true
}

variable "client_affinity_enabled" {
  description = "Enable client affinity (ARR)."
  type        = bool
  default     = false
}

variable "identity_type" {
  description = "Type of managed identity."
  type        = string
  default     = "SystemAssigned"

  validation {
    condition = contains([
      "SystemAssigned",
      "UserAssigned",
      "SystemAssigned, UserAssigned"
    ], var.identity_type)
    error_message = "identity_type must be one of: SystemAssigned, UserAssigned, SystemAssigned, UserAssigned."
  }
}


variable "identity_ids" {
  description = "List of User Assigned Identity IDs (required if identity_type is UserAssigned or SystemAssigned, UserAssigned)."
  type        = list(string)
  default     = []

  validation {
    condition = (
      var.identity_type == "UserAssigned" ||
      var.identity_type == "SystemAssigned, UserAssigned"
    ) ? length(var.identity_ids) > 0 : true

    error_message = "identity_ids must be provided when identity_type is UserAssigned or SystemAssigned, UserAssigned."
  }

}

variable "app_settings" {
  description = "App settings for the Linux Web App."
  type        = map(string)
  default     = {}
}

variable "site_config" {
  description = "Site configuration for the Linux Web App."
  type = object({
    always_on                         = bool
    ftps_state                        = string
    minimum_tls_version               = string
    http2_enabled                     = bool
    health_check_path                 = string
    health_check_eviction_time_in_min = number
    python_version                    = string
    node_version                      = string
    dotnet_version                    = string
    java_version                      = string
  })
  default = {
    always_on                         = true
    ftps_state                        = "Disabled"
    minimum_tls_version               = "1.2"
    http2_enabled                     = true
    health_check_path                 = "/"
    health_check_eviction_time_in_min = 10
    python_version                    = null
    node_version                      = null
    dotnet_version                    = null
    java_version                      = null
  }
}

variable "logs_enabled" {
  description = "Enable logs block."
  type        = bool
  default     = true
}

variable "logs" {
  description = "Logging configuration."
  type = object({
    detailed_error_messages = bool
    failed_request_tracing  = bool
    http_logs_enabled       = bool
    http_logs = object({
      retention_in_days = number
      retention_in_mb   = number
    })
  })
  default = {
    detailed_error_messages = true
    failed_request_tracing  = true
    http_logs_enabled       = true
    http_logs = {
      retention_in_days = 7
      retention_in_mb   = 35
    }
  }
}

variable "connection_strings" {
  description = "List of connection strings."
  type = list(object({
    name  = string
    type  = string
    value = string
  }))
  default = []

  validation {
    condition = alltrue([
      for cs in var.connection_strings :
      contains(["SQLAzure", "SQLServer", "MySQL", "PostgreSQL", "Custom"], cs.type)
    ])
    error_message = "Each connection string type must be one of: SQLAzure, SQLServer, MySQL, PostgreSQL, Custom."
  }
}

variable "tags" {
  description = "Tags to apply to the resource."
  type        = map(string)
  default     = {}
}

variable "timeouts" {
  description = "Timeout configuration."
  type = object({
    create = string
    update = string
    delete = string
  })
  default = {
    create = "30m"
    update = "30m"
    delete = "30m"
  }
}
