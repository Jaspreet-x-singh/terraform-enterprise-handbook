# Chapter 14  
## Terraform State (Deep Dive)

Terraform’s state system is one of its most powerful — and most misunderstood — components. State enables Terraform to understand what infrastructure exists, how it relates to your configuration, and what changes need to be applied. Without state, Terraform would have no way to track resources, detect drift, or generate accurate plans.

This chapter provides a deep, practical exploration of Terraform state, including how it works, how to secure it, how to manage it at scale, and how to recover from state corruption.

---

## 14.1 What Is Terraform State?

Terraform state is a JSON document that stores metadata about the infrastructure Terraform manages. It acts as a mapping between:

- **Terraform configuration** (desired state)
- **Real infrastructure** (actual state)
- **Terraform’s internal representation** (state file)

State allows Terraform to:

- Track resource IDs  
- Detect drift  
- Understand dependencies  
- Generate execution plans  
- Perform updates safely  
- Avoid recreating existing resources  

---

## 14.2 Why Terraform Needs State

Terraform needs state for several reasons:

### 14.2.1 Mapping Resources to Real Infrastructure  
Terraform must know which resources it created.

Example:

```
azurerm_storage_account.sa → /subscriptions/.../storageAccounts/stapp001
```

### 14.2.2 Performance  
Without state, Terraform would need to query every resource on every plan.

### 14.2.3 Dependency Graph  
State stores relationships between resources.

### 14.2.4 Drift Detection  
Terraform compares state with real infrastructure to detect changes.

---

## 14.3 What’s Inside the State File?

A typical state file contains:

- Resource IDs  
- Attributes  
- Metadata  
- Dependencies  
- Outputs  
- Sensitive values (unless redacted)  

Example snippet:

```json
{
  "resources": [
    {
      "type": "azurerm_resource_group",
      "name": "rg",
      "instances": [
        {
          "attributes": {
            "id": "/subscriptions/.../resourceGroups/rg-app",
            "location": "eastus",
            "name": "rg-app"
          }
        }
      ]
    }
  ]
}
```

---

## 14.4 Local vs Remote State

### 14.4.1 Local State (Default)

Stored in:

```
terraform.tfstate
```

Good for:

- Learning  
- Small projects  
- Prototyping  

Not suitable for:

- Teams  
- Production  
- CI/CD  

---

### 14.4.2 Remote State (Recommended)

Remote backends store state in a secure, centralized location.

Supported backends:

- Azure Storage  
- AWS S3  
- GCP Storage  
- Terraform Cloud  
- Consul  

Remote state provides:

- Encryption  
- Access control  
- State locking  
- Collaboration  
- Auditability  

---

## 14.5 Configuring Remote State

### 14.5.1 Azure Storage Backend

```hcl
terraform {
  backend "azurerm" {
    resource_group_name  = "rg-tfstate"
    storage_account_name = "sttfstate001"
    container_name       = "tfstate"
    key                  = "prod.terraform.tfstate"
  }
}
```

### 14.5.2 AWS S3 Backend

```hcl
terraform {
  backend "s3" {
    bucket = "tfstate-prod"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}
```

### 14.5.3 GCP Storage Backend

```hcl
terraform {
  backend "gcs" {
    bucket = "tfstate-prod"
    prefix = "terraform/state"
  }
}
```

---

## 14.6 State Locking

State locking prevents multiple users or pipelines from modifying state simultaneously.

Supported by:

- Azure Storage  
- S3 + DynamoDB  
- GCP Storage  
- Terraform Cloud  

Example (AWS):

```hcl
dynamodb_table = "tfstate-lock"
```

Locking prevents:

- Race conditions  
- Corrupted state  
- Partial updates  

---

## 14.7 State Drift

Drift occurs when infrastructure changes outside Terraform.

Examples:

- Someone modifies a resource in the portal  
- A script updates a configuration  
- A resource is deleted manually  

Terraform detects drift during:

- `plan`  
- `apply`  
- `refresh`  

Example drift output:

```
~ azurerm_subnet.subnet
    address_prefix: "10.0.1.0/24" → "10.0.2.0/24"
```

---

## 14.8 State Manipulation Commands

### 14.8.1 `terraform state list`

Lists all resources in state.

### 14.8.2 `terraform state show`

Shows details of a resource.

### 14.8.3 `terraform state rm`

Removes a resource from state (dangerous).

Example:

```bash
terraform state rm azurerm_storage_account.sa
```

### 14.8.4 `terraform state mv`

Moves resources within state.

Example:

```bash
terraform state mv module.old.module.network module.new.module.network
```

Used for refactoring.

---

## 14.9 Importing Existing Infrastructure

Terraform can import existing resources into state.

Example:

```bash
terraform import azurerm_resource_group.rg /subscriptions/.../resourceGroups/rg-app
```

Import does **not** generate configuration.  
You must write the `.tf` files manually.

---

## 14.10 State File Security

State files often contain:

- Passwords  
- Keys  
- Connection strings  
- Certificates  

Security best practices:

### 14.10.1 Encrypt State at Rest  
Azure Storage, S3, and GCP all support encryption.

### 14.10.2 Restrict Access  
Use RBAC or IAM.

### 14.10.3 Never Commit State to Git  
Add to `.gitignore`:

```
terraform.tfstate
terraform.tfstate.backup
```

### 14.10.4 Use Remote Backends  
Local state is too risky for teams.

---

## 14.11 State Corruption and Recovery

State corruption can occur due to:

- Failed apply  
- Manual edits  
- Backend issues  
- Merge conflicts  
- Partial updates  

### 14.11.1 Recovery Options

#### Option 1 — Use State Backup  
Terraform automatically creates:

```
terraform.tfstate.backup
```

#### Option 2 — Restore from Backend Versioning  
Azure Storage, S3, and GCP support versioning.

#### Option 3 — Rebuild State with Import  
Slow but reliable.

---

## 14.12 State in Multi-Module Architectures

Each root module should have its own state.

Example:

```
network/
compute/
monitoring/
```

Each with:

- Its own backend  
- Its own state file  
- Its own CI/CD pipeline  

This prevents:

- Cross-module corruption  
- Accidental destruction  
- Tight coupling  

---

## 14.13 Best Practices for State Management

### 14.13.1 Always Use Remote State  
Local state is unsafe for teams.

### 14.13.2 Enable State Locking  
Prevents corruption.

### 14.13.3 Use One State File per Root Module  
Avoid monolithic state.

### 14.13.4 Never Edit State Manually  
Use `terraform state` commands instead.

### 14.13.5 Protect State with RBAC/IAM  
Limit access to admins only.

### 14.13.6 Enable Versioning  
Allows rollback.

### 14.13.7 Avoid Storing Secrets in State  
Use data sources instead.

---

## 14.14 Summary

Terraform state is the backbone of Terraform’s execution model.  
Key takeaways:

- State maps Terraform configuration to real infrastructure  
- Remote state is essential for teams  
- State locking prevents corruption  
- Drift detection ensures accuracy  
- State manipulation commands enable refactoring  
- State must be encrypted and access-controlled  
- Never store secrets in state  
- Never edit state manually  

In the next chapter, we will explore **remote state backends**, including Azure Storage, S3, GCS, and Terraform Cloud — and how to choose the right backend for your organization.
