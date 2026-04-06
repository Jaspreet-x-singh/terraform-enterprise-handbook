```hcl
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "storage-rg"
  location = "australiaeast"
}

resource "azurerm_storage_account" "sa" {
  name                     = "examplestorageacct123"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
```
