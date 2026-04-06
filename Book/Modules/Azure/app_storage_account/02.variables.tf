variable "storage_account_name" {
  type        = string
  description = "The name of the Storage Account. Must be globally unique and follow Azure naming rules."
  validation {
    condition     = length(var.storage_account_name) >= 3 && length(var.storage_account_name) <= 24 && can(regex("^[a-z0-9]+$", var.storage_account_name))
    error_message = "Storage Account name must be 3–24 characters, lowercase alphanumeric only."
  }
}

variable "resource_group_name" {
  type        = string
  description = "The name of the Resource Group in which the Storage Account will be created."
}

variable "location" {
  type        = string
  description = "The Azure region where the Storage Account will be deployed."
}

variable "account_tier" {
  type        = string
  description = "The performance tier of the Storage Account. Valid options: Standard or Premium."
  validation {
    condition     = var.account_tier == "Standard" || var.account_tier == "Premium"
    error_message = "Valid values for account_tier are: Standard, Premium."
  }
}

variable "account_replication_type" {
  type        = string
  description = "The replication strategy for the Storage Account. Examples: LRS, GRS, RAGRS, ZRS."
  validation {
    condition     = contains(["LRS", "GRS", "RAGRS", "ZRS"], var.account_replication_type)
    error_message = "Valid values: LRS, GRS, RAGRS, ZRS."
  }
}

variable "account_kind" {
  type        = string
  description = "The kind of Storage Account. Defaults to StorageV2."
  default     = "StorageV2"
  validation {
    condition     = contains(["Storage", "StorageV2", "BlobStorage", "BlockBlobStorage", "FileStorage"], var.account_kind)
    error_message = "Valid values: Storage, StorageV2, BlobStorage, BlockBlobStorage, FileStorage."
  }
}

variable "access_tier" {
  type        = string
  description = "The access tier for BlobStorage and StorageV2 accounts. Valid values: Hot, Cool."
  default     = "Hot"
  validation {
    condition     = contains(["Hot", "Cool"], var.access_tier)
    error_message = "Valid values for access_tier are: Hot, Cool."
  }
}

variable "min_tls_version" {
  type        = string
  description = "The minimum supported TLS version for the Storage Account."
  default     = "TLS1_2"
  validation {
    condition     = contains(["TLS1_0", "TLS1_1", "TLS1_2"], var.min_tls_version)
    error_message = "Valid values: TLS1_0, TLS1_1, TLS1_2."
  }
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to assign to the Storage Account."
  default     = {}
}

variable "cross_tenant_replication_enabled" {
  type        = bool
  description = "Enable cross-tenant replication. Optional."
  default     = null
}

variable "https_traffic_only_enabled" {
  type        = bool
  description = "Force HTTPS-only traffic. Optional."
  default     = null
}

variable "allow_nested_items_to_be_public" {
  type        = bool
  description = "Allow nested items to be public. Optional."
  default     = null
}

variable "shared_access_key_enabled" {
  type        = bool
  description = "Enable shared access keys. Optional."
  default     = null
}

variable "public_network_access_enabled" {
  type        = bool
  description = "Enable public network access. Optional."
  default     = null
}

variable "default_to_oauth_authentication" {
  type        = bool
  description = "Default to OAuth authentication for Azure Files. Optional."
  default     = null
}

variable "is_hns_enabled" {
  type        = bool
  description = "Enable hierarchical namespace (Data Lake Gen2). Optional."
  default     = null
}

variable "nfsv3_enabled" {
  type        = bool
  description = "Enable NFSv3 protocol. Optional."
  default     = null
}

variable "large_file_share_enabled" {
  type        = bool
  description = "Enable large file shares. Optional."
  default     = null
}

variable "local_user_enabled" {
  type        = bool
  description = "Enable local users for SFTP. Optional."
  default     = null
}

variable "infrastructure_encryption_enabled" {
  type        = bool
  description = "Enable infrastructure-level encryption. Optional."
  default     = null
}

variable "network_rules" {
  type = object({
    default_action             = optional(string)
    bypass                     = optional(list(string))
    ip_rules                   = optional(list(string))
    virtual_network_subnet_ids = optional(list(string))
  })
  description = "Network rules block. Optional."
  default     = null
}

variable "static_website" {
  type = object({
    index_document     = string
    error_404_document = string
  })
  description = "Static website configuration. Optional."
  default     = null
}

variable "azure_files_authentication" {
  type = object({
    directory_type = string
  })
  description = "Azure Files authentication settings. Optional."
  default     = null
}

variable "cors_rule" {
  type = list(object({
    allowed_headers    = list(string)
    allowed_methods    = list(string)
    allowed_origins    = list(string)
    exposed_headers    = list(string)
    max_age_in_seconds = number
  }))
  description = "CORS rules for the storage account. Optional."
  default     = null
}

variable "containers" {
  description = "List of storage containers to create."
  type = list(object({
    name                  = string
    container_access_type = optional(string, "private")
  }))
  default = []
}

variable "enable_blob_versioning" {
  description = "Enable blob versioning on the Storage Account."
  type        = bool
  default     = true
}

variable "enable_soft_delete" {
  description = "Enable soft delete for blobs."
  type        = bool
  default     = true
}

variable "soft_delete_retention_days" {
  description = "Number of days to retain soft deleted blobs."
  type        = number
  default     = 7
}

variable "enable_lifecycle_management" {
  description = "Enable lifecycle rules."
  type        = bool
  default     = false
}

variable "lifecycle_rules" {
  description = "Lifecycle management rules."
  type = list(object({
    name    = string
    enabled = bool
    filters = object({
      prefix_match = optional(list(string), [])
      blob_types   = list(string)
    })
    actions = object({
      base_blob = optional(object({
        tier_to_cool_after_days_since_modification_greater_than    = optional(number)
        tier_to_archive_after_days_since_modification_greater_than = optional(number)
        delete_after_days_since_modification_greater_than          = optional(number)
      }), null)
    })
  }))
  default = []
}


