# Chapter 8  
## Writing Your First Terraform Configuration

Now that you understand Terraform’s architecture, language, and environment strategies, it’s time to build your first real Terraform configuration. This chapter walks through the entire process step-by-step, from setting up your directory structure to deploying your first cloud resource.

We’ll use Azure for examples, but the concepts apply to AWS, GCP, and any other provider.

---

## 8.1 Prerequisites

Before writing your first configuration, ensure you have:

- Terraform installed  
- Azure CLI (or AWS CLI / gcloud) installed  
- A cloud subscription  
- Authentication configured (CLI login, service principal, or managed identity)  

Verify Terraform installation:

```bash
terraform version
```

Verify Azure login:

```bash
az login
```

---

## 8.2 Creating Your First Terraform Project

Start by creating a new directory:

```bash
mkdir terraform-first-project
cd terraform-first-project
```

Terraform loads all `.tf` files in this directory.

---

## 8.3 Defining the Provider

Create a file named `providers.tf`:

```hcl
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.100"
    }
  }
}

provider "azurerm" {
  features {}
}
```

This:

- Pins the provider version  
- Loads the AzureRM provider  
- Enables required features  

---

## 8.4 Creating Your First Resource Group

Create `main.tf`:

```hcl
resource "azurerm_resource_group" "rg" {
  name     = "rg-first-terraform"
  location = "eastus"
}
```

This is your first Terraform-managed resource.

---

## 8.5 Initializing Terraform

Run:

```bash
terraform init
```

Terraform will:

- Download the AzureRM provider  
- Initialize the working directory  
- Prepare the backend (if configured)  

---

## 8.6 Previewing Changes with `terraform plan`

Run:

```bash
terraform plan
```

Terraform will show:

- What will be created  
- What will be updated  
- What will be destroyed  

Example output:

```
# azurerm_resource_group.rg will be created
+ name     = "rg-first-terraform"
+ location = "eastus"
```

This is your safety net before applying changes.

---

## 8.7 Applying the Configuration

Run:

```bash
terraform apply
```

Terraform will:

- Ask for confirmation  
- Create the resource group  
- Save the state file  

You should see:

```
Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
```

---

## 8.8 Inspecting the State

Terraform stores metadata in `terraform.tfstate`.

View state:

```bash
terraform show
```

Never edit the state file manually.

---

## 8.9 Adding More Resources

Let’s add a storage account.

Update `main.tf`:

```hcl
resource "azurerm_storage_account" "sa" {
  name                     = "stfirsttf001"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
```

Run:

```bash
terraform plan
terraform apply
```

Terraform will create the storage account and update the state.

---

## 8.10 Using Variables

Create `variables.tf`:

```hcl
variable "location" {
  type        = string
  default     = "eastus"
  description = "Azure region"
}
```

Update `main.tf`:

```hcl
location = var.location
```

Now you can override the location:

```bash
terraform apply -var="location=eastus2"
```

---

## 8.11 Using Outputs

Create `outputs.tf`:

```hcl
output "resource_group_id" {
  value = azurerm_resource_group.rg.id
}
```

After apply:

```bash
terraform output
```

---

## 8.12 Destroying Infrastructure

To delete everything:

```bash
terraform destroy
```

Terraform will:

- Show what will be deleted  
- Ask for confirmation  
- Remove resources  
- Update state  

---

## 8.13 Common Mistakes Beginners Make

### 8.13.1 Hardcoding Values  
Use variables instead.

### 8.13.2 Editing State Files  
Never do this manually.

### 8.13.3 Forgetting to Pin Provider Versions  
This can break deployments.

### 8.13.4 Using Workspaces for Environments  
Use directory-based environments instead.

### 8.13.5 Not Using `terraform fmt`  
Always format your code.

---

## 8.14 Summary

In this chapter, you learned how to:

- Initialize a Terraform project  
- Configure providers  
- Create your first resources  
- Use variables and outputs  
- Apply and destroy infrastructure  
- Understand the Terraform workflow  

This foundation prepares you for more advanced topics.

In the next chapter, we will explore **Terraform’s dependency graph**, a critical concept for understanding how Terraform orchestrates infrastructure changes.
