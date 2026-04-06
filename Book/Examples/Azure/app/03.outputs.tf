output "app_service_plan_id" {
  description = "The ID of the App Service Plan."
  value       = module.app_service_plan.id
}

output "app_service_plan_name" {
  description = "The name of the App Service Plan."
  value       = module.app_service_plan.app_service_plan_name
}


output "app_service_plan_sku" {
  description = "The SKU of the App Service Plan."
  value       = module.app_service_plan.sku_name
}

output "linux_app_service_id" {
  description = "The ID of the Linux App Service."
  value       = module.linux_app_service.id

}
output "linux_app_service_name" {
  description = "The name of the Linux App Service."
  value       = module.linux_app_service.name

}

output "linux_app_default_hostname" {
  description = "The default hostname of the Linux App Service."
  value       = module.linux_app_service.default_hostname

}

output "linux_app_identity_principal_id" {
  description = "The principal ID of the managed identity assigned to the Linux App Service."
  value       = module.linux_app_service.identity_principal_id

}