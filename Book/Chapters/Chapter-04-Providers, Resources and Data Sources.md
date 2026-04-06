# Chapter 4  
## Providers, Resources, and Data Sources

Terraform’s power comes from its ability to interact with thousands of APIs across cloud platforms, SaaS products, and on‑prem systems. This is made possible through **providers**, which expose **resources** and **data sources**. Understanding these three concepts is essential for writing effective Terraform configurations and designing reusable modules.

This chapter provides a deep, practical exploration of providers, resources, and data sources — how they work, how they interact, and how to use them in production environments.

---

## 4.1 What Are Providers?

Providers are Terraform plugins that allow Terraform to interact with external systems.  
They act as the “API clients” for Terraform.

A provider:

- Authenticates with an API  
- Defines resources  
- Defines data sources  
- Implements CRUD operations  
- Validates configuration  
- Manages API rate limits  
- Handles errors and retries  

Terraform itself does **not** know how to create a virtual network or a storage account — the provider does.

---

## 4.2 Configuring Providers

Providers are declared in the root module using the `provider` block.

Example (AzureRM):

```hcl
provider "azurerm" {
  features {}
}
```

Example (AWS):

```hcl
provider "aws" {
  region = "us-east-1"
}
```

Example (GitHub):

```hcl
provider "github" {
  token = var.github_token
}
```

### 4.2.1 Provider Version Pinning

Always pin provider versions in production:

```hcl
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.100"
    }
  }
}
```

Version pinning prevents breaking changes from affecting deployments.

---

## 4.3 Provider Authentication

Each provider has its own authentication model.

### AzureRM Authentication Options

- Azure CLI  
- Managed Identity  
- Service Principal  
- OIDC (GitHub Actions → Azure)  

Example (Service Principal):

```hcl
provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
}
```

### AWS Authentication Options

- Access keys  
- IAM roles  
- Instance profiles  
- OIDC  

### GitHub Authentication

```hcl
provider "github" {
  token = var.github_token
}
```

---

## 4.4 What Are Resources?

Resources are the core building blocks of Terraform.  
A resource represents a piece of infrastructure that Terraform manages.

Examples:

- Azure Resource Group  
- AWS VPC  
- GCP Storage Bucket  
- Kubernetes Deployment  
- GitHub Repository  
- Cloudflare DNS Record  

### 4.4.1 Resource Block Structure

```hcl
resource "<provider>_<type>" "<name>" {
  # arguments
}
```

Example:

```hcl
resource "azurerm_resource_group" "rg" {
  name     = "rg-app"
  location = "eastus"
}
```

### 4.4.2 Resource Arguments vs Attributes

- **Arguments**: Inputs you provide  
- **Attributes**: Outputs the provider returns  

Example:

```hcl
resource "azurerm_storage_account" "sa" {
  name                     = "stapp001"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

output "sa_id" {
  value = azurerm_storage_account.sa.id
}
```

---

## 4.5 Resource Lifecycle

Terraform manages the full lifecycle of resources:

- Create  
- Read  
- Update  
- Delete  

Terraform determines the correct action based on:

- Configuration  
- State  
- Provider responses  

### 4.5.1 Lifecycle Meta‑Arguments

```hcl
lifecycle {
  prevent_destroy      = true
  ignore_changes       = [tags]
  create_before_destroy = true
}
```

These rules help manage:

- Zero‑downtime deployments  
- Sensitive resources  
- Drift tolerance  

---

## 4.6 What Are Data Sources?

Data sources allow Terraform to **read** information from external systems without creating anything.

Examples:

- Get current Azure client config  
- Lookup an existing VNet  
- Fetch a GitHub repository  
- Read a Kubernetes namespace  

### 4.6.1 Data Source Block Structure

```hcl
data "<provider>_<type>" "<name>" {
  # arguments
}
```

Example:

```hcl
data "azurerm_client_config" "current" {}
```

### 4.6.2 Data Sources Are Read‑Only

Data sources:

- Do not create resources  
- Do not modify infrastructure  
- Only fetch information  

They are essential for:

- Referencing existing infrastructure  
- Cross‑module communication  
- Dynamic configuration  

---

## 4.7 Resources vs Data Sources

| Feature | Resource | Data Source |
|---------|----------|-------------|
| Creates infrastructure | Yes | No |
| Updates infrastructure | Yes | No |
| Deletes infrastructure | Yes | No |
| Reads existing infrastructure | Yes | Yes |
| Used for lookups | Sometimes | Always |
| Appears in state | Yes | Yes (read-only) |

---

## 4.8 Using Data Sources in Modules

Data sources are commonly used inside modules to:

- Fetch existing networks  
- Lookup resource groups  
- Retrieve identity information  
- Query secrets  
- Fetch subscription details  

Example:

```hcl
data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}
```

---

## 4.9 Provider Aliases

Aliases allow multiple provider configurations.

Example:

```hcl
provider "azurerm" {
  alias           = "east"
  features        = {}
  subscription_id = var.sub_east
}

provider "azurerm" {
  alias           = "west"
  features        = {}
  subscription_id = var.sub_west
}
```

Use cases:

- Multi‑region deployments  
- Multi‑subscription deployments  
- Cross‑cloud deployments  

---

## 4.10 Provider Inheritance in Modules

Modules do not automatically inherit providers.  
You must pass them explicitly:

```hcl
module "network" {
  source   = "./modules/network"
  providers = {
    azurerm = azurerm.east
  }
}
```

This is essential for:

- Multi‑region architectures  
- Multi‑subscription deployments  
- Cross‑tenant deployments  

---

## 4.11 Common Provider Pitfalls

### 4.11.1 Missing Authentication  
Terraform cannot authenticate → provider fails.

### 4.11.2 Incorrect Provider Version  
Breaking changes cause failures.

### 4.11.3 Provider Rate Limits  
APIs throttle requests → retries occur.

### 4.11.4 Provider Bugs  
Providers are open-source → bugs happen.

### 4.11.5 Provider Deprecations  
Old arguments removed → configuration breaks.

---

## 4.12 Summary

Providers, resources, and data sources form the foundation of Terraform.  
They enable Terraform to interact with cloud platforms, SaaS systems, and on‑prem infrastructure.

Key takeaways:

- Providers connect Terraform to external APIs  
- Resources create and manage infrastructure  
- Data sources read existing infrastructure  
- Provider aliases enable multi‑region and multi‑subscription deployments  
- Modules require explicit provider passing  

In the next chapter, we will explore **variables, locals, and outputs**, which are essential for writing reusable and maintainable Terraform configurations.