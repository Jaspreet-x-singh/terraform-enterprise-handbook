# Chapter 5  
## Variables, Locals, and Outputs

Variables, locals, and outputs are the core building blocks that make Terraform configurations flexible, reusable, and maintainable. They allow you to parameterize modules, compute intermediate values, and expose useful information to other modules or external systems.

This chapter provides a deep dive into how these constructs work, how to use them effectively, and how to design production‑grade variable interfaces for modules.

---

## 5.1 Variables: Inputs to Your Configuration

Variables allow you to parameterize Terraform configurations.  
They make modules reusable across environments and prevent hardcoding values.

### 5.1.1 Declaring Variables

Variables are declared using the `variable` block:

```hcl
variable "location" {
  type        = string
  description = "Azure region for deployment"
  default     = "eastus"
}
```

### 5.1.2 Variable Types

Terraform supports:

- `string`
- `number`
- `bool`
- `list`
- `set`
- `map`
- `object`
- `tuple`
- `any`

Example (object):

```hcl
variable "tags" {
  type = map(string)
}
```

### 5.1.3 Required vs Optional Variables

A variable is **required** if no default is provided.

```hcl
variable "resource_group_name" {
  type = string
}
```

A variable is **optional** if it has a default:

```hcl
variable "environment" {
  type    = string
  default = "dev"
}
```

### 5.1.4 Sensitive Variables

Mark variables as sensitive to hide them in logs:

```hcl
variable "client_secret" {
  type      = string
  sensitive = true
}
```

---

## 5.2 Passing Variables

Variables can be passed using:

### 5.2.1 CLI Flags

```bash
terraform apply -var="location=eastus2"
```

### 5.2.2 `.tfvars` Files

`terraform.tfvars`:

```hcl
location = "eastus2"
```

Environment‑specific:

```
dev.tfvars
test.tfvars
prod.tfvars
```

### 5.2.3 Environment Variables

```bash
export TF_VAR_location=eastus2
```

---

## 5.3 Validation Rules

Terraform allows validation blocks inside variables:

```hcl
variable "environment" {
  type = string

  validation {
    condition     = contains(["dev", "test", "prod"], var.environment)
    error_message = "Environment must be dev, test, or prod."
  }
}
```

Validation ensures correctness and prevents misconfigurations.

---

## 5.4 Locals: Computed Values

Locals allow you to compute intermediate values that simplify your configuration.

### 5.4.1 Declaring Locals

```hcl
locals {
  full_name = "${var.project}-${var.environment}"
}
```

### 5.4.2 Use Cases for Locals

- Naming conventions  
- Derived values  
- Complex expressions  
- Reducing duplication  
- Conditional logic  

Example:

```hcl
locals {
  tags = merge(
    var.tags,
    {
      environment = var.environment
      project     = var.project
    }
  )
}
```

Locals improve readability and maintainability.

---

## 5.5 Outputs: Exposing Values

Outputs expose values after Terraform applies changes.

### 5.5.1 Declaring Outputs

```hcl
output "resource_group_id" {
  value = azurerm_resource_group.rg.id
}
```

### 5.5.2 Sensitive Outputs

```hcl
output "client_secret" {
  value     = azurerm_key_vault_secret.secret.value
  sensitive = true
}
```

### 5.5.3 Output Use Cases

- Passing values to parent modules  
- Passing values to CI/CD pipelines  
- Debugging  
- Documentation  

---

## 5.6 Variables, Locals, and Outputs in Modules

Modules rely heavily on these constructs.

### 5.6.1 Module Inputs

```hcl
module "network" {
  source              = "./modules/network"
  resource_group_name = var.resource_group_name
  location            = var.location
}
```

### 5.6.2 Module Outputs

Child module:

```hcl
output "vnet_id" {
  value = azurerm_virtual_network.vnet.id
}
```

Parent module:

```hcl
vnet_id = module.network.vnet_id
```

---

## 5.7 Designing Production‑Grade Variable Interfaces

### 5.7.1 Use Descriptions Everywhere

Every variable should have a description.

### 5.7.2 Use Types for Safety

Avoid `any` unless absolutely necessary.

### 5.7.3 Use Validation Blocks

Prevent invalid inputs early.

### 5.7.4 Use Optional Variables with Defaults

Make modules easier to consume.

### 5.7.5 Use Objects for Complex Inputs

Example:

```hcl
variable "subnets" {
  type = list(object({
    name           = string
    address_prefix = string
  }))
}
```

---

## 5.8 Conditional Logic with Variables and Locals

Terraform supports conditionals:

```hcl
locals {
  sku = var.environment == "prod" ? "Premium" : "Standard"
}
```

Use cases:

- Environment‑specific SKUs  
- Optional resources  
- Feature flags  

---

## 5.9 Dynamic Blocks

Dynamic blocks allow you to generate nested blocks programmatically.

Example:

```hcl
dynamic "ip_rule" {
  for_each = var.ip_rules
  content {
    ip_address = ip_rule.value
  }
}
```

Dynamic blocks are powerful but should be used sparingly for readability.

---

## 5.10 Summary

Variables, locals, and outputs are essential for writing reusable, maintainable, and scalable Terraform configurations.

Key takeaways:

- Variables parameterize modules  
- Locals compute intermediate values  
- Outputs expose useful information  
- Validation ensures correctness  
- Complex inputs should use objects  
- Dynamic blocks enable flexible nested structures  

In the next chapter, we will explore **Terraform’s language features**, including expressions, functions, loops, and conditionals.