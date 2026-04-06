############################################
# Log Analytics Workspace
############################################

variable "workspace_name" {
  description = "The name of the Log Analytics Workspace."
  type        = string
}

variable "location" {
  description = "Azure region where resources will be deployed."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the Resource Group in which resources will be created."
  type        = string
}

variable "workspace_sku" {
  description = "The SKU of the Log Analytics Workspace."
  type        = string
  default     = "PerGB2018"

  validation {
    condition     = contains(["Free", "Standalone", "PerNode", "PerGB2018"], var.workspace_sku)
    error_message = "workspace_sku must be one of: Free, Standalone, PerNode, PerGB2018."
  }
}

variable "workspace_retention_days" {
  description = "Retention period for logs in the workspace."
  type        = number
  default     = 30

  validation {
    condition     = var.workspace_retention_days >= 30 && var.workspace_retention_days <= 730
    error_message = "workspace_retention_days must be between 30 and 730."
  }
}

############################################
# Application Insights
############################################

variable "app_insights_name" {
  description = "The name of the Application Insights instance."
  type        = string
}

variable "app_insights_application_type" {
  description = "Type of Application Insights application."
  type        = string
  default     = "web"

  validation {
    condition     = contains(["web", "other"], lower(var.app_insights_application_type))
    error_message = "app_insights_application_type must be either 'web' or 'other'."
  }
}

# Optional Application Insights arguments (only applied when non-null)

variable "disable_ip_masking" {
  description = "Disable IP masking for Application Insights."
  type        = bool
  default     = null
}

variable "local_authentication_disabled" {
  description = "Disable local authentication for Application Insights."
  type        = bool
  default     = null
}

variable "internet_ingestion_enabled" {
  description = "Enable ingestion over public internet."
  type        = bool
  default     = null
}

variable "internet_query_enabled" {
  description = "Enable queries over public internet."
  type        = bool
  default     = null
}

variable "force_customer_storage_for_profiler" {
  description = "Force customer storage for profiler."
  type        = bool
  default     = null
}

variable "sampling_percentage" {
  description = "Sampling percentage for Application Insights."
  type        = number
  default     = null
}

variable "daily_data_cap_in_gb" {
  description = "Daily data cap in GB."
  type        = number
  default     = null
}

variable "daily_data_cap_notifications_disabled" {
  description = "Disable notifications for daily data cap."
  type        = bool
  default     = null
}

variable "retention_in_days" {
  description = "Retention override for Application Insights."
  type        = number
  default     = null
}

variable "tags" {
  description = "Tags to apply to Application Insights."
  type        = map(string)
  default     = {}
}

############################################
# Diagnostic Settings
############################################

variable "enabled" {
  description = "Global module enable switch."
  type        = bool
  default     = true
}

variable "diagnostic_setting_enable" {
  description = "Enable diagnostic settings."
  type        = bool
  default     = false
}

variable "storage_account_id" {
  description = "Storage account ID for diagnostic logs."
  type        = string
  default     = null
}

variable "category" {
  description = "Log category for enabled_log block."
  type        = string
  default     = "AppTraces"
}
