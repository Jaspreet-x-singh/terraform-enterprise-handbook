variable "app_service_plan_name" {
  description = "The name of the App Service Plan to create."
  type        = string
}

variable "os_type" {
  description = "The operating system type for the App Service Plan."
  type        = string
  default     = "Linux"
}

variable "sku_name" {
  description = "The SKU name for the App Service Plan."
  type        = string
  default     = "F1"
}

variable "worker_count" {
  description = "The number of workers to be allocated to the App Service Plan."
  type        = number
  default     = null
}

variable "zone_balancing_enabled" {
  description = "Whether to enable zone balancing for the App Service Plan."
  type        = bool
  default     = false
}

variable "app_service_environment_id" {
  description = "The ID of the App Service Environment to which the App Service Plan should be associated."
  type        = string
  default     = null
}

variable "tags" {
  description = "A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

variable "timeouts" {
  description = "Custom timeouts for create, read, update, and delete operations."
  type = object({
    create = optional(string)
    read   = optional(string)
    update = optional(string)
    delete = optional(string)
  })
  default = {}
}

variable "linux_app_name" {
  description = "Name of the Linux App Service."
  type        = string
}

variable "https_only" {
  description = "Whether to enable HTTPS only for the Linux App Service."
  type        = bool
  default     = true
}

variable "client_affinity_enabled" {
  description = "Whether to enable client affinity (ARR affinity) for the Linux App Service."
  type        = bool
  default     = false
}

variable "identity_type" {
  description = "The type of managed identity to use for the Linux App Service. Valid values are 'SystemAssigned', 'UserAssigned', 'SystemAssigned, UserAssigned', or 'None'."
  type        = string
  default     = "SystemAssigned"
}

variable "app_settings" {
  description = "A map of application settings to be applied to the Linux App Service."
  type        = map(string)
  default     = {}
}
variable "site_config" {
  description = "A set of site configuration settings for the Linux App Service."
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
}

variable "logs" {
  description = "A set of logging configuration settings for the Linux App Service."
  type = object({
    detailed_error_messages = bool
    failed_request_tracing  = bool
    http_logs_enabled       = bool
    http_logs = object({
      retention_in_days = number
      retention_in_mb   = number
    })
  })
}
variable "connection_strings" {
  description = "A list of connection strings to be applied to the Linux App Service."
  type = list(object({
    name  = string
    type  = string
    value = string
  }))
  default = []
}