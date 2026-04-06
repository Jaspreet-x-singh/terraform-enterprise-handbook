# ---------------------------------------------------------
# App Service Plan
# ---------------------------------------------------------
module "app_service_plan" {
  source                     = "git::https://github.com/Jaspreet-x-singh/terraform-azure-modules.git//modules/app_service_plan?ref=main"
  app_service_plan_name      = var.app_service_plan_name
  resource_group_name        = data.terraform_remote_state.rg.outputs.resource_group_name
  location                   = data.terraform_remote_state.rg.outputs.resource_group_location
  os_type                    = var.os_type
  sku_name                   = var.sku_name
  worker_count               = var.worker_count
  zone_balancing_enabled     = var.zone_balancing_enabled
  app_service_environment_id = var.app_service_environment_id
  tags                       = var.tags
  timeouts                   = var.timeouts
}

# ---------------------------------------------------------
# Linux App Service
# ---------------------------------------------------------
module "linux_app_service" {
  source                  = "git::https://github.com/Jaspreet-x-singh/terraform-azure-modules.git//modules/app_service?ref=main"
  name                    = var.linux_app_name
  resource_group_name     = data.terraform_remote_state.rg.outputs.resource_group_name
  location                = data.terraform_remote_state.rg.outputs.resource_group_location
  app_service_plan_id     = module.app_service_plan.id
  https_only              = var.https_only
  client_affinity_enabled = var.client_affinity_enabled
  identity_type           = var.identity_type
  app_settings            = var.app_settings
  site_config             = var.site_config
  logs                    = var.logs
  connection_strings      = var.connection_strings
  tags                    = var.tags
  timeouts                = var.timeouts
}
