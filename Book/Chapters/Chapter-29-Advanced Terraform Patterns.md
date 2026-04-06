# Chapter 29  
## Advanced Terraform Patterns

By this point, you’ve mastered the fundamentals of Terraform, module design, CI/CD, governance, and security. Now it’s time to explore the advanced patterns that unlock Terraform’s full power. These patterns help you build highly dynamic, scalable, and expressive infrastructure-as-code that adapts to complex real-world requirements.

This chapter covers dynamic blocks, advanced looping strategies, complex object types, conditional resource creation, module composition, and advanced provider usage.

---

## 29.1 Why Advanced Patterns Matter

Advanced patterns enable:

- Highly reusable modules  
- Complex infrastructure modeling  
- Reduced duplication  
- Cleaner code  
- More expressive logic  
- Better scalability  
- Easier maintenance  

These patterns are essential for enterprise-scale Terraform.

---

## 29.2 Dynamic Blocks

Dynamic blocks allow you to generate nested blocks programmatically.

### 29.2.1 Example: Dynamic NSG Rules

```hcl
dynamic "security_rule" {
  for_each = var.rules
  content {
    name                       = security_rule.value.name
    priority                   = security_rule.value.priority
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = security_rule.value.port
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}
```

### 29.2.2 When to Use Dynamic Blocks

- Repeating nested blocks  
- Complex resource configurations  
- Variable-length lists  

### 29.2.3 When *Not* to Use Dynamic Blocks

- When a simple `for_each` on resources is cleaner  
- When readability suffers  

---

## 29.3 Advanced for_each Patterns

### 29.3.1 for_each with Maps

```hcl
resource "azurerm_subnet" "subnet" {
  for_each = var.subnets

  name           = each.key
  address_prefix = each.value
}
```

### 29.3.2 for_each with Complex Objects

```hcl
for_each = { for s in var.subnets : s.name => s }
```

### 29.3.3 for_each with Conditional Filtering

```hcl
for_each = {
  for s in var.subnets :
  s.name => s
  if s.enabled
}
```

---

## 29.4 Advanced Count Patterns

### 29.4.1 Conditional Resource Creation

```hcl
resource "azurerm_public_ip" "pip" {
  count = var.enable_public_ip ? 1 : 0
}
```

### 29.4.2 Count with Lists

```hcl
resource "azurerm_network_interface" "nic" {
  count = length(var.vm_names)
}
```

### 29.4.3 Count vs for_each

Use **count** when:

- Order matters  
- You’re working with lists  

Use **for_each** when:

- You need stable resource addressing  
- You’re working with maps or objects  

---

## 29.5 Complex Object Types

Complex objects allow you to model real-world infrastructure.

### 29.5.1 Example: Subnet Object

```hcl
variable "subnets" {
  type = list(object({
    name           = string
    address_prefix = string
    nsg            = optional(string)
  }))
}
```

### 29.5.2 Example: AKS Node Pool Object

```hcl
variable "node_pools" {
  type = map(object({
    vm_size   = string
    node_count = number
    mode       = string
  }))
}
```

---

## 29.6 Merging and Transforming Objects

### 29.6.1 Merging Maps

```hcl
locals {
  tags = merge(var.default_tags, var.custom_tags)
}
```

### 29.6.2 Transforming Lists into Maps

```hcl
locals {
  subnet_map = { for s in var.subnets : s.name => s }
}
```

### 29.6.3 Filtering Lists

```hcl
locals {
  prod_subnets = [
    for s in var.subnets : s
    if s.environment == "prod"
  ]
}
```

---

## 29.7 Conditional Expressions

### 29.7.1 Simple Condition

```hcl
sku = var.environment == "prod" ? "Premium" : "Standard"
```

### 29.7.2 Nested Conditions

```hcl
tier = var.environment == "prod" ? "P1" : var.environment == "test" ? "S1" : "F1"
```

### 29.7.3 Conditional Blocks

```hcl
resource "azurerm_monitor_autoscale_setting" "autoscale" {
  count = var.enable_autoscale ? 1 : 0
}
```

---

## 29.8 Advanced Module Composition

### 29.8.1 Modules Calling Modules

```hcl
module "network" {
  source = "../network"
}

module "compute" {
  source     = "../compute"
  subnet_id  = module.network.subnet_id
}
```

### 29.8.2 Interface Modules

Wrap multiple modules:

```hcl
module "application" {
  source = "../application"
}
```

### 29.8.3 Factory Modules

Create multiple resources dynamically:

```hcl
module "subnets" {
  for_each = var.subnets
  source   = "../subnet"
}
```

---

## 29.9 Advanced Provider Usage

### 29.9.1 Multiple Provider Instances

```hcl
provider "azurerm" {
  alias           = "eastus"
  features        = {}
  subscription_id = var.sub1
}

provider "azurerm" {
  alias           = "westus"
  features        = {}
  subscription_id = var.sub2
}
```

### 29.9.2 Assigning Providers to Resources

```hcl
resource "azurerm_resource_group" "rg" {
  provider = azurerm.eastus
}
```

### 29.9.3 Cross-Subscription Deployments

Useful for:

- Hub-spoke networks  
- Shared services  
- Multi-region architectures  

---

## 29.10 Data Source Patterns

### 29.10.1 Lookup Existing Resources

```hcl
data "azurerm_resource_group" "rg" {
  name = var.rg_name
}
```

### 29.10.2 Use Data Sources for Secrets

```hcl
data "azurerm_key_vault_secret" "db" {
  name         = "db-password"
  key_vault_id = var.kv_id
}
```

### 29.10.3 Use Data Sources for Dynamic Inputs

Examples:

- Subnet IDs  
- VNet IDs  
- Key Vault IDs  

---

## 29.11 Advanced Output Patterns

### 29.11.1 Sensitive Outputs

```hcl
output "password" {
  value     = data.azurerm_key_vault_secret.db.value
  sensitive = true
}
```

### 29.11.2 Complex Outputs

```hcl
output "subnet_map" {
  value = { for s in azurerm_subnet.subnet : s.name => s.id }
}
```

---

## 29.12 Error Handling Patterns

### 29.12.1 Validation Blocks

```hcl
validation {
  condition     = var.node_count >= 1
  error_message = "Node count must be at least 1."
}
```

### 29.12.2 Fail Fast Patterns

Use validation to prevent invalid configurations early.

---

## 29.13 Performance Optimization Patterns

### 29.13.1 Reduce Data Source Calls  
Cache values in locals.

### 29.13.2 Split Large Modules  
Improves plan/apply performance.

### 29.13.3 Use Remote State  
Avoids repeated API calls.

---

## 29.14 Anti‑Patterns

### 29.14.1 Overusing Dynamic Blocks  
Hurts readability.

### 29.14.2 Overusing Count  
Leads to unstable resource addressing.

### 29.14.3 Hardcoding Values  
Reduces reusability.

### 29.14.4 Overly Complex Modules  
Hard to maintain.

---

## 29.15 Best Practices Summary

### Use  
- Dynamic blocks for nested repetition  
- for_each for stable addressing  
- Complex objects for real-world modeling  
- Conditional expressions for flexibility  
- Module composition for scalability  
- Multiple providers for multi-region deployments  

### Avoid  
- Overly complex logic  
- Hardcoded values  
- Manual resource duplication  

---

## 29.16 Summary

Advanced Terraform patterns unlock the full expressive power of infrastructure-as-code.  
Key takeaways:

- Dynamic blocks enable flexible nested structures  
- for_each is essential for scalable resource creation  
- Complex objects model real-world infrastructure  
- Conditional logic enables environment-specific behavior  
- Module composition creates reusable building blocks  
- Multiple providers support multi-region and multi-subscription deployments  
- Avoid anti-patterns that reduce readability and maintainability  

In the next chapter, we will explore **Terraform Multi-Cloud Strategies**, including patterns for Azure, AWS, and GCP interoperability.
