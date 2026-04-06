resource "azurerm_storage_account" "storage" {
  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type
  account_kind             = var.account_kind
  access_tier              = var.access_tier

  # Versioning & soft delete
  blob_properties {
    versioning_enabled = var.enable_blob_versioning

    delete_retention_policy {
      days = var.soft_delete_retention_days
    }

    dynamic "cors_rule" {
      for_each = var.cors_rule == null ? [] : var.cors_rule
      content {
        allowed_headers    = cors_rule.value.allowed_headers
        allowed_methods    = cors_rule.value.allowed_methods
        allowed_origins    = cors_rule.value.allowed_origins
        exposed_headers    = cors_rule.value.exposed_headers
        max_age_in_seconds = cors_rule.value.max_age_in_seconds
      }
    }
  }



  # Optional booleans (only set if not null)
  cross_tenant_replication_enabled  = var.cross_tenant_replication_enabled
  https_traffic_only_enabled        = var.https_traffic_only_enabled
  allow_nested_items_to_be_public   = var.allow_nested_items_to_be_public
  shared_access_key_enabled         = var.shared_access_key_enabled
  public_network_access_enabled     = var.public_network_access_enabled
  default_to_oauth_authentication   = var.default_to_oauth_authentication
  is_hns_enabled                    = var.is_hns_enabled
  nfsv3_enabled                     = var.nfsv3_enabled
  large_file_share_enabled          = var.large_file_share_enabled
  local_user_enabled                = var.local_user_enabled
  infrastructure_encryption_enabled = var.infrastructure_encryption_enabled
  min_tls_version                   = var.min_tls_version
  tags                              = var.tags

  #############################
  # Optional nested blocks
  #############################

  # network_rules
  dynamic "network_rules" {
    for_each = var.network_rules == null ? [] : [var.network_rules]
    content {
      default_action             = lookup(network_rules.value, "default_action", null)
      bypass                     = lookup(network_rules.value, "bypass", null)
      ip_rules                   = lookup(network_rules.value, "ip_rules", null)
      virtual_network_subnet_ids = lookup(network_rules.value, "virtual_network_subnet_ids", null)
    }
  }

  # static_website
  dynamic "static_website" {
    for_each = var.static_website == null ? [] : [var.static_website]
    content {
      index_document     = static_website.value.index_document
      error_404_document = static_website.value.error_404_document
    }
  }

  # azure_files_authentication
  dynamic "azure_files_authentication" {
    for_each = var.azure_files_authentication == null ? [] : [var.azure_files_authentication]
    content {
      directory_type = azure_files_authentication.value.directory_type
    }
  }
}

resource "azurerm_storage_container" "containers" {
  for_each = { for c in var.containers : c.name => c }

  name                  = each.value.name
  storage_account_id    = azurerm_storage_account.storage.id
  container_access_type = lookup(each.value, "container_access_type", "private")
}

resource "azurerm_storage_management_policy" "policy" {
  count              = var.enable_lifecycle_management ? 1 : 0
  storage_account_id = azurerm_storage_account.storage.id

  dynamic "rule" {
    for_each = { for r in var.lifecycle_rules : r.name => r }

    content {
      name    = rule.value.name
      enabled = rule.value.enabled

      filters {
        prefix_match = lookup(rule.value.filters, "prefix_match", [])
        blob_types   = rule.value.filters.blob_types
      }

      actions {
        dynamic "base_blob" {
          for_each = rule.value.actions.base_blob == null ? [] : [rule.value.actions.base_blob]

          content {
            tier_to_cool_after_days_since_modification_greater_than    = lookup(base_blob.value, "tier_to_cool_after_days_since_modification_greater_than", null)
            tier_to_archive_after_days_since_modification_greater_than = lookup(base_blob.value, "tier_to_archive_after_days_since_modification_greater_than", null)
            delete_after_days_since_modification_greater_than          = lookup(base_blob.value, "delete_after_days_since_modification_greater_than", null)
          }
        }
      }
    }
  }
}



