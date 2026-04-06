# Chapter 17  
## Terraform Modules (Deep Dive)

Terraform modules are the foundation of scalable, reusable, and maintainable infrastructure-as-code. They allow you to encapsulate logic, enforce standards, and create repeatable building blocks that can be used across environments, teams, and organizations.

This chapter provides a comprehensive deep dive into module design, structure, best practices, anti-patterns, and real-world enterprise usage.

---

## 17.1 What Is a Terraform Module?

A module is a collection of `.tf` files in a directory.  
Every Terraform configuration is implicitly a module — the **root module**.

Modules allow you to:

- Reuse infrastructure patterns  
- Encapsulate complexity  
- Enforce naming conventions  
- Standardize resource creation  
- Reduce duplication  
- Improve maintainability  
- Enable multi-environment deployments  

---

## 17.2 Types of Modules

### 17.2.1 Root Modules  
The entry point for Terraform execution.

Example:

```
environments/
  dev/
    main.tf
    variables.tf
    outputs.tf
```

### 17.2.2 Child Modules  
Reusable modules called by root modules.

Example:

```
modules/
  network/
  compute/
  monitoring/
```

### 17.2.3 Public Registry Modules  
Modules published on the Terraform Registry.

Example:

```
terraform-azurerm-network
terraform-aws-vpc
terraform-google-gke
```

---

## 17.3 Module Structure

A typical module includes:

```
modules/
  network/
    main.tf
    variables.tf
    outputs.tf
    locals.tf
    README.md
```

### 17.3.1 `main.tf`  
Contains resources and data sources.

### 17.3.2 `variables.tf`  
Defines module inputs.

### 17.3.3 `outputs.tf`  
Exposes module outputs.

### 17.3.4 `locals.tf`  
Contains computed values.

### 17.3.5 `README.md`  
Documents usage, inputs, outputs, and examples.

---

## 17.4 Calling a Module

Example:

```hcl
module "network" {
  source              = "./modules/network"
  resource_group_name = var.resource_group_name
  location            = var.location
}
```

Modules can be sourced from:

- Local paths  
- Git repositories  
- Terraform Registry  
- Private registries  

---

## 17.5 Module Inputs

Inputs are defined using variables.

Example:

```hcl
variable "location" {
  type        = string
  description = "Azure region"
}
```

Inputs should:

- Have clear descriptions  
- Use types  
- Use validation blocks  
- Use defaults when appropriate  

---

## 17.6 Module Outputs

Outputs expose values to parent modules.

Example:

```hcl
output "vnet_id" {
  value = azurerm_virtual_network.vnet.id
}
```

Outputs should:

- Be minimal  
- Expose only what is needed  
- Avoid exposing secrets  

---

## 17.7 Locals in Modules

Locals simplify complex expressions.

Example:

```hcl
locals {
  name_prefix = "${var.project}-${var.environment}"
}
```

Use locals for:

- Naming conventions  
- Derived values  
- Merging tags  
- Conditional logic  

---

## 17.8 Module Versioning

Modules should be versioned using Git tags.

Example:

```hcl
source = "git::https://github.com/org/network-module.git?ref=v1.2.0"
```

Versioning ensures:

- Stability  
- Predictability  
- Safe upgrades  

---

## 17.9 Module Composition

Modules can call other modules.

Example:

```
module "network" → module "subnets" → module "nsg"
```

This creates a modular architecture.

---

## 17.10 Designing Production-Grade Modules

### 17.10.1 Use Clear Naming Conventions  
Consistent naming improves readability.

### 17.10.2 Use Validation Blocks  
Prevent invalid inputs.

### 17.10.3 Use Optional Variables  
Make modules flexible.

### 17.10.4 Use Objects for Complex Inputs  
Avoid long lists of variables.

### 17.10.5 Avoid Hardcoding Values  
Use variables and locals.

### 17.10.6 Avoid Provider Configuration Inside Modules  
Providers should be configured in root modules.

---

## 17.11 Module Anti-Patterns

### 17.11.1 Monolithic Modules  
Modules that do too much are hard to maintain.

### 17.11.2 Modules That Wrap a Single Resource  
Adds unnecessary complexity.

### 17.11.3 Modules That Contain Provider Blocks  
Breaks provider inheritance.

### 17.11.4 Modules That Output Secrets  
State files will store them.

### 17.11.5 Modules Without Documentation  
Hard to use and maintain.

---

## 17.12 Module Testing

Modules should be tested using:

- `terraform validate`  
- `terraform plan`  
- `tflint`  
- Terratest (Go-based testing framework)  

Testing ensures:

- Correct behavior  
- Safe upgrades  
- Predictable outputs  

---

## 17.13 Module Registries

Terraform supports:

### 17.13.1 Public Registry  
Open-source modules.

### 17.13.2 Private Registry  
Enterprise module sharing.

Benefits:

- Versioning  
- Documentation  
- Discovery  
- Governance  

---

## 17.14 Real-World Module Architecture

A scalable enterprise architecture:

```
modules/
  network/
  compute/
  monitoring/
  security/
  storage/
  identity/

environments/
  dev/
  test/
  prod/
```

Each environment uses the same modules with different variables.

---

## 17.15 Example: Network Module

### `variables.tf`

```hcl
variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "address_space" {
  type = list(string)
}
```

### `main.tf`

```hcl
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-${var.resource_group_name}"
  resource_group_name = var.resource_group_name
  location            = var.location
  address_space       = var.address_space
}
```

### `outputs.tf`

```hcl
output "vnet_id" {
  value = azurerm_virtual_network.vnet.id
}
```

---

## 17.16 Summary

Terraform modules are essential for building scalable, reusable, and maintainable infrastructure.  
Key takeaways:

- Modules encapsulate logic and enforce standards  
- Root modules orchestrate deployments  
- Child modules provide reusable building blocks  
- Inputs, outputs, and locals define module interfaces  
- Versioning ensures stability  
- Avoid monolithic or overly simple modules  
- Use documentation and testing for reliability  

In the next chapter, we will explore **module design patterns**, including composition, layering, and environment-specific architectures.
