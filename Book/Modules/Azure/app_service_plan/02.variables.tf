variable "app_service_plan_name" {
  description = "The name of the App Service Plan."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the Resource Group in which to create the App Service Plan."
  type        = string
}

variable "location" {
  description = "The Azure region where the App Service Plan should be created."
  type        = string
}

variable "os_type" {
  description = "The operating system for the App Service Plan. Possible values: Linux, Windows."
  type        = string

  validation {
    condition     = contains(["Linux", "Windows", "WindowsContainer"], var.os_type)
    error_message = "os_type must be either 'Linux', 'Windows', or 'WindowsContainer'."
  }

}

variable "sku_name" {
  description = "The SKU for the App Service Plan (e.g., B1, S1, P1v3)."
  type        = string
  validation {
    condition = contains([
      "F1", "D1",
      "B1", "B2", "B3",
      "S1", "S2", "S3",
      "P1v2", "P2v2", "P3v2",
      "P1v3", "P2v3", "P3v3",
      "P1", "P2", "P3",
      "I1", "I2", "I3",
      "I1v2", "I2v2", "I3v2",
      "EP1", "EP2", "EP3",
      "Y1"
    ], var.sku_name)
    error_message = "Invalid sku_name. Must be a valid App Service Plan SKU."
  }
}


variable "app_service_environment_id" {
  description = "The ID of the App Service Environment to create the plan in."
  type        = string
  default     = null
}

variable "worker_count" {
  description = "The number of workers for the App Service Plan."
  type        = number
  default     = null

  validation {
    condition = (
      var.worker_count == null ||
      can(regex("^(P[1-3](v2|v3)?|I[1-3](v2)?|EP[1-3])$", var.sku_name))
    )
    error_message = "worker_count is only valid for Premium, PremiumV2, PremiumV3, Isolated, IsolatedV2, and Elastic Premium SKUs."
  }
}

variable "zone_balancing_enabled" {
  description = "Should the App Service Plan be zone redundant."
  type        = bool
  default     = false

  validation {
    condition = (
      var.zone_balancing_enabled == false ||
      can(regex("^(P[1-3]v3|I[1-3]v2)$", var.sku_name))
    )
    error_message = "zone_balancing_enabled is only supported for PremiumV3 and IsolatedV2 SKUs."
  }
}

variable "tags" {
  description = "A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

variable "timeouts" {
  description = "Timeout configuration for the App Service Plan."
  type = object({
    create = optional(string)
    read   = optional(string)
    update = optional(string)
    delete = optional(string)
  })
  default = {}
}
