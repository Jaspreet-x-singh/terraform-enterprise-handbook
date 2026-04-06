# Chapter 11  
## Expressions, Functions, and Dynamic Blocks

Terraform’s declarative syntax is simple on the surface, but underneath it lies a powerful expression engine that enables dynamic configuration, conditional logic, loops, and computed values. These features allow you to write flexible, reusable, and production‑grade infrastructure code.

This chapter explores Terraform expressions, built‑in functions, loops, conditionals, and dynamic blocks in depth.

---

## 11.1 What Are Expressions?

Expressions are the building blocks of Terraform logic.  
They allow you to compute values dynamically.

Examples:

```hcl
var.location
azurerm_resource_group.rg.name
"${var.project}-${var.environment}"
```

Expressions can be used in:

- Resource arguments  
- Locals  
- Variables  
- Outputs  
- Module inputs  
- Dynamic blocks  

---

## 11.2 Types of Expressions

### 11.2.1 Literal Expressions

```hcl
"eastus"
42
true
```

### 11.2.2 Variable References

```hcl
var.environment
```

### 11.2.3 Resource Attribute References

```hcl
azurerm_storage_account.sa.id
```

### 11.2.4 Function Calls

```hcl
upper(var.name)
```

### 11.2.5 Conditional Expressions

```hcl
var.environment == "prod" ? "Premium" : "Standard"
```

### 11.2.6 For Expressions

```hcl
[for s in var.subnets : s.name]
```

---

## 11.3 Terraform Functions

Terraform includes a rich set of built‑in functions.

### 11.3.1 String Functions

```hcl
upper(var.name)
lower(var.name)
replace(var.name, "old", "new")
format("app-%s", var.environment)
```

### 11.3.2 Numeric Functions

```hcl
min(1, 5)
max(10, 20)
floor(3.7)
ceil(3.1)
```

### 11.3.3 Collection Functions

```hcl
length(var.subnets)
contains(var.environments, "prod")
merge(var.tags, local.default_tags)
keys(var.map)
values(var.map)
```

### 11.3.4 Encoding Functions

```hcl
jsonencode(var.config)
yamldecode(file("config.yaml"))
```

### 11.3.5 File Functions

```hcl
file("config.json")
templatefile("cloud-init.tftpl", { hostname = var.hostname })
```

---

## 11.4 Conditionals

Terraform supports ternary conditionals:

```hcl
var.environment == "prod" ? "Premium" : "Standard"
```

Use cases:

- Environment‑specific SKUs  
- Optional resources  
- Feature flags  
- Conditional module inputs  

Example:

```hcl
resource "azurerm_monitor_diagnostic_setting" "diag" {
  count = var.enable_diagnostics ? 1 : 0
}
```

---

## 11.5 Loops in Terraform

Terraform supports two looping constructs:

- `count`  
- `for_each`  

### 11.5.1 Using `count`

```hcl
resource "azurerm_network_interface" "nic" {
  count = var.nic_count
  name  = "nic-${count.index}"
}
```

Use `count` when:

- Resources are identical  
- You need simple indexing  

### 11.5.2 Using `for_each`

```hcl
resource "azurerm_subnet" "subnet" {
  for_each = var.subnets

  name           = each.value.name
  address_prefix = each.value.address_prefix
}
```

Use `for_each` when:

- Resources are unique  
- You need stable addressing  
- You want named keys  

---

## 11.6 For Expressions

For expressions allow you to transform collections.

### 11.6.1 List Transformation

```hcl
[for s in var.subnets : s.name]
```

### 11.6.2 Map Transformation

```hcl
{ for s in var.subnets : s.name => s.address_prefix }
```

### 11.6.3 Filtering

```hcl
[for s in var.subnets : s if s.type == "private"]
```

---

## 11.7 Dynamic Blocks

Dynamic blocks generate nested blocks programmatically.

Example:

```hcl
dynamic "ip_rule" {
  for_each = var.ip_rules
  content {
    ip_address = ip_rule.value
  }
}
```

Use cases:

- NSG rules  
- Storage firewall rules  
- AKS node pools  
- Application Gateway listeners  

### 11.7.1 When to Use Dynamic Blocks

Use dynamic blocks when:

- The number of nested blocks is variable  
- The nested structure is complex  
- You want to avoid duplication  

### 11.7.2 When *Not* to Use Dynamic Blocks

Avoid dynamic blocks when:

- A simple `for_each` on a resource is enough  
- Readability suffers  
- The nested structure is static  

---

## 11.8 Complex Data Structures

Terraform supports:

### 11.8.1 Lists

```hcl
["dev", "test", "prod"]
```

### 11.8.2 Maps

```hcl
{
  environment = "dev"
  project     = "app"
}
```

### 11.8.3 Objects

```hcl
{
  name   = string
  subnet = string
}
```

### 11.8.4 Tuples

```hcl
[1, "two", true]
```

### 11.8.5 Nested Structures

```hcl
variable "subnets" {
  type = list(object({
    name           = string
    address_prefix = string
  }))
}
```

---

## 11.9 Template Files

Terraform supports external templates using `templatefile`.

Example:

```hcl
user_data = templatefile("${path.module}/cloud-init.tftpl", {
  hostname = var.hostname
})
```

Templates are useful for:

- Cloud‑init scripts  
- JSON policies  
- YAML configurations  
- Kubernetes manifests  

---

## 11.10 Best Practices for Expressions and Functions

### 11.10.1 Prefer `for_each` over `count`  
Stable addressing is safer.

### 11.10.2 Use locals for complex expressions  
Improves readability.

### 11.10.3 Avoid deeply nested dynamic blocks  
They reduce clarity.

### 11.10.4 Use validation blocks  
Catch errors early.

### 11.10.5 Use objects for structured inputs  
Avoid long lists of variables.

---

## 11.11 Summary

Terraform’s expression engine is powerful and flexible.  
Key takeaways:

- Expressions compute dynamic values  
- Functions transform and manipulate data  
- Conditionals enable environment‑specific logic  
- Loops allow scalable resource creation  
- Dynamic blocks generate nested structures  
- Complex data types support modular design  

In the next chapter, we will explore **provisioners**, including why they are discouraged and how to use them safely when necessary.

