data "terraform_remote_state" "rg" {
  backend = "azurerm"
  config = {
    resource_group_name  = "tfstate-rg"
    storage_account_name = "tfstatedevazure"
    container_name       = "tfstate-dev"
    key                  = "resourcegroup.tfstate"
  }
}
