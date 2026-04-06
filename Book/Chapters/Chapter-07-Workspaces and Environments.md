# Chapter 7  
## Workspaces and Environments

Managing multiple environments — such as development, testing, staging, and production — is a core requirement for any real-world Terraform implementation. Terraform provides several mechanisms for environment separation, including **workspaces**, **directory-based environments**, **remote state separation**, and **multi‑module architecture patterns**.

This chapter explores how to design scalable, safe, and maintainable environment strategies using Terraform.

---

## 7.1 What Are Environments?

An environment is an isolated instance of your infrastructure.  
Common environments include:

- **dev** — for experimentation  
- **test** — for integration testing  
- **stage** — for pre‑production validation  
- **prod** — for live workloads  

Each environment typically has:

- Its own state  
- Its own variables  
- Its own naming conventions  
- Its own access controls  
- Its own CI/CD workflow  

Terraform must ensure that changes in one environment do not affect others.

---

## 7.2 Terraform Workspaces

Terraform workspaces allow multiple state files to exist within the same configuration directory.

### 7.2.1 Listing Workspaces

```bash
terraform workspace list
```

### 7.2.2 Creating a Workspace

```bash
terraform workspace new dev
```

### 7.2.3 Switching Workspaces

```bash
terraform workspace select prod
```

### 7.2.4 Deleting a Workspace

```bash
terraform workspace delete test
```

---

## 7.3 How Workspaces Work

Workspaces create **separate state files** under the same configuration.

Example (Azure Storage backend):

```
terraform.tfstate
terraform.tfstate.d/dev/terraform.tfstate
terraform.tfstate.d/prod/terraform.tfstate
```

Each workspace has its own:

- State  
- Outputs  
- Resource tracking  

---

## 7.4 When to Use Workspaces

Workspaces are useful for:

- Small projects  
- Quick prototypes  
- Single‑module deployments  
- Lightweight environment separation  

However, they are **not recommended** for large-scale enterprise environments.

---

## 7.5 When *Not* to Use Workspaces

Workspaces are **not ideal** when:

- You have multiple root modules  
- You need strict environment isolation  
- You use CI/CD pipelines  
- You require different providers per environment  
- You need different resource counts per environment  
- You need different module versions per environment  

Workspaces are often misused as a replacement for proper environment architecture.

---

## 7.6 Directory-Based Environments (Recommended)

The recommended pattern for enterprise Terraform is **directory-based environments**.

Example:

```
environments/
  dev/
    main.tf
    terraform.tfvars
  test/
    main.tf
    terraform.tfvars
  prod/
    main.tf
    terraform.tfvars
```

Each environment has:

- Its own root module  
- Its own backend  
- Its own variables  
- Its own CI/CD workflow  

This provides **true isolation**.

---

## 7.7 Remote State Separation

Each environment should have its own remote state backend.

Example (Azure Storage):

```
tfstate-dev
tfstate-test
tfstate-prod
```

Example backend configuration:

```hcl
backend "azurerm" {
  resource_group_name  = "rg-tfstate"
  storage_account_name = "sttfstate001"
  container_name       = "tfstate-dev"
  key                  = "terraform.tfstate"
}
```

This ensures:

- Isolation  
- Security  
- Auditability  
- Predictability  

---

## 7.8 Environment-Specific Variables

Each environment should have its own `.tfvars` file.

Example: `dev.tfvars`

```hcl
location = "eastus"
sku      = "Standard"
```

Example: `prod.tfvars`

```hcl
location = "eastus2"
sku      = "Premium"
```

This allows:

- Different SKUs  
- Different regions  
- Different scaling settings  
- Different naming conventions  

---

## 7.9 Environment-Specific Providers

Some environments require different provider configurations.

Example:

```hcl
provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}
```

Each environment can pass a different subscription ID.

---

## 7.10 Multi-Module Environment Architecture

A scalable enterprise architecture uses:

- Multiple root modules  
- Shared child modules  
- Environment directories  
- Remote state per environment  

Example:

```
live/
  dev/
    network/
    compute/
    monitoring/
  prod/
    network/
    compute/
    monitoring/
modules/
  network/
  compute/
  monitoring/
```

This pattern is used by:

- AWS Landing Zone  
- Azure Enterprise Scale  
- Google Cloud Foundation  

---

## 7.11 CI/CD for Environments

Each environment should have its own pipeline.

Example:

- `deploy-dev.yml`  
- `deploy-test.yml`  
- `deploy-prod.yml`  

Each pipeline:

- Loads its own backend  
- Loads its own variables  
- Runs its own plan/apply  
- Has its own approvals  

This prevents accidental production deployments.

---

## 7.12 Naming Conventions for Environments

Use consistent naming:

```
dev
test
stage
prod
```

Avoid:

```
development
testing
preprod
production
```

Short names reduce errors and improve readability.

---

## 7.13 Environment Promotion Workflows

A common pattern:

1. Deploy to **dev**  
2. Validate  
3. Promote to **test**  
4. Validate  
5. Promote to **prod**  

Promotion can be:

- Manual  
- Automated  
- GitOps-based  

---

## 7.14 Best Practices for Environment Management

### 7.14.1 Never Share State Between Environments  
Each environment must have its own backend.

### 7.14.2 Never Use Workspaces for Production  
Use directory-based environments instead.

### 7.14.3 Use Separate Pipelines  
Each environment should have its own CI/CD workflow.

### 7.14.4 Use Environment-Specific Variables  
Avoid hardcoding environment values.

### 7.14.5 Use Consistent Naming  
Predictable naming reduces errors.

---

## 7.15 Summary

Workspaces and environments are essential for managing multi‑environment Terraform deployments.  
Key takeaways:

- Workspaces provide lightweight state separation  
- Directory-based environments provide true isolation  
- Remote state must be separated per environment  
- CI/CD pipelines should be environment-specific  
- Multi-module architectures scale best in enterprises  

In the next chapter, we will begin **Part II — Terraform in Practice**, starting with writing your first configuration.
