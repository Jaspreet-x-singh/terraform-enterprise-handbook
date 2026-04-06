variable "name" {
  description = "The name of the Resource Group."
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "Resource Group name cannot be empty."
  }
}

variable "location" {
  description = "Azure region where the Resource Group will be created."
  type        = string

  validation {
    condition     = length(var.location) > 0
    error_message = "Location cannot be empty."
  }
}

variable "tags" {
  description = "Tags to apply to the Resource Group."
  type        = map(string)
  default     = {}
}
