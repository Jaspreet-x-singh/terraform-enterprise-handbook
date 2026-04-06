terraform {
  backend "azurerm" {
    resource_group_name  = "tfstate-rg"
    storage_account_name = "tfstatedevazure"
    container_name       = "tfstate-dev"
    key                  = "app.tfstate"
  }
}
