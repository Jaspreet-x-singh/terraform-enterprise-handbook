# ---------------------------------------------------------
# Storage Account
# ---------------------------------------------------------
module "app_storage_account" {
  source                            = "git::https://github.com/Jaspreet-x-singh/terraform-azure-modules.git//modules/app_storage_account?ref=main"
  storage_account_name              = var.storage_account_name
  resource_group_name               = data.terraform_remote_state.rg.outputs.resource_group_name
  location                          = data.terraform_remote_state.rg.outputs.resource_group_location
  account_tier                      = var.account_tier
  account_replication_type          = var.account_replication_type
  account_kind                      = var.account_kind
  access_tier                       = var.access_tier
  enable_blob_versioning            = var.enable_blob_versioning
  soft_delete_retention_days        = var.soft_delete_retention_days
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
  network_rules                     = var.network_rules
  static_website                    = var.static_website
  azure_files_authentication        = var.azure_files_authentication
  cors_rule                         = var.cors_rule
  containers                        = var.containers
  enable_lifecycle_management       = var.enable_lifecycle_management
  lifecycle_rules                   = var.lifecycle_rules
}