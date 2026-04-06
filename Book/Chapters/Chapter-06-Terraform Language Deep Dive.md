# Chapter 6  
## Terraform Language Deep Dive

Terraform uses the HashiCorp Configuration Language (HCL), a declarative language designed for clarity, readability, and predictability. While HCL looks simple on the surface, it includes powerful features such as expressions, functions, loops, conditionals, dynamic blocks, and complex data structures.

This chapter provides a deep dive into the Terraform language, enabling you to write expressive, maintainable, and production‑grade configurations.

---

## 6.1 HCL: HashiCorp Configuration Language

HCL is:

- **Declarative**  
- **Human‑readable**  
- **Machine‑friendly**  
- **Extensible**  
- **Strongly typed**  

Terraform uses HCL to define:

- Resources  
- Data sources  
- Variables  
- Outputs  
- Modules  
- Providers  
- Locals  
- Expressions  

---

## 6.2 Terraform File Structure

Terraform files typically include:

- `main.tf` — resources and modules  
- `variables.tf` — variable definitions  
- `outputs.tf` — outputs  
- `locals.tf` — computed values  
- `providers.tf` — provider configuration  
- `versions.tf` — required versions  
- `terraform.tfvars` — variable values  

Terraform loads all `.tf` files in a directory automatically.

---

## 6.3 Expressions

Expressions allow you to compute values dynamically.

### 6.3.1 Basic Expressions

```hcl
var.location
azurerm_resource_group.rg.name
```

### 6.3.2 String Interpolation

```hcl
"${var.project}-${var.environment}"
```

Modern HCL allows direct interpolation:

```hcl
"${var.project}-${var.environment}"
```

or simply:

```hcl
"${var.project}-${var.environment}"
```

### 6.3.3 Numeric Expressions

```hcl
var.instance_count + 2
```

### 6.3.4 Boolean Expressions

```hcl
var.environment == "prod"
```

---

## 6.4 Terraform Functions

Terraform includes dozens of built‑in functions.

### 6.4.1 String Functions

```hcl
upper(var.name)
lower(var.name)
replace(var.name, "old", "new")
```

### 6.4.2 Numeric Functions

```hcl
min(1, 5)
max(10, 20)
```

### 6.4.3 Collection Functions

```hcl
length(var.subnets)
contains(var.environments, "prod")
merge(var.tags, local.default_tags)
```

### 6.4.4 Encoding Functions

```hcl
jsonencode(var.config)
yamldecode(file("config.yaml"))
```

### 6.4.5 File Functions

```hcl
file("config.json")
templatefile("template.tftpl", { name = var.name })
```

---

## 6.5 Conditionals

Terraform supports ternary conditionals:

```hcl
var.environment == "prod" ? "Premium" : "Standard"
```

Use cases:

- Environment‑specific SKUs  
- Optional resources  
- Feature flags  

---

## 6.6 Loops in Terraform

Terraform supports two types of loops:

- `for_each`  
- `count`  

### 6.6.1 `count`

```hcl
resource "azurerm_network_interface" "nic" {
  count = var.nic_count
  name  = "nic-${count.index}"
}
```

Use `count` when:

- Resources are identical  
- You need simple indexing  

### 6.6.2 `for_each`

```hcl
resource "azurerm_subnet" "subnet" {
  for_each = var.subnets

  name           = each.value.name
  address_prefix = each.value.address_prefix
}
```

Use `for_each` when:

- Resources are unique  
- You need named keys  
- You want stable addressing  

---

## 6.7 Dynamic Blocks

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

Dynamic blocks should be used sparingly for readability.

---

## 6.8 Complex Data Structures

Terraform supports:

### 6.8.1 Lists

```hcl
["dev", "test", "prod"]
```

### 6.8.2 Maps

```hcl
{
  environment = "dev"
  project     = "app"
}
```

### 6.8.3 Objects

```hcl
{
  name   = string
  subnet = string
}
```

### 6.8.4 Tuples

```hcl
[1, "two", true]
```

### 6.8.5 Nested Structures

```hcl
variable "subnets" {
  type = list(object({
    name           = string
    address_prefix = string
  }))
}
```

---

## 6.9 Template Files

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

---

## 6.10 Terraform Language Best Practices

### 6.10.1 Prefer `for_each` over `count`

`for_each` provides stable addressing and better readability.

### 6.10.2 Use locals for complex expressions

```hcl
locals {
  full_name = "${var.project}-${var.environment}"
}
```

### 6.10.3 Use objects for structured inputs

Avoid long lists of variables.

### 6.10.4 Avoid deeply nested dynamic blocks

They reduce readability.

### 6.10.5 Use validation blocks

Prevent invalid inputs early.

---

## 6.11 Summary

Terraform’s language is simple yet powerful.  
Key takeaways:

- HCL is declarative and strongly typed  
- Expressions and functions enable dynamic configuration  
- Conditionals and loops provide flexibility  
- Dynamic blocks generate nested structures  
- Complex data types support modular design  
- Template files enable external configuration  

In the next chapter, we will explore **workspaces and environment management**, a critical topic for multi‑environment deployments.
