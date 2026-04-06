resource "azurerm_service_plan" "asp" {
  name                = var.app_service_plan_name
  resource_group_name = var.resource_group_name
  location            = var.location
  os_type             = var.os_type
  sku_name            = var.sku_name

  # Optional arguments
  app_service_environment_id = var.app_service_environment_id
  worker_count               = var.worker_count
  zone_balancing_enabled     = var.zone_balancing_enabled
  tags                       = var.tags

  # Optional block: timeouts
  timeouts {
    create = var.timeouts.create
    read   = var.timeouts.read
    update = var.timeouts.update
    delete = var.timeouts.delete
  }
}