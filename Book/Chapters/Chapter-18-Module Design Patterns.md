# Chapter 18  
## Module Design Patterns

Modules are the backbone of scalable Terraform architectures. But simply *having* modules isn’t enough — the real power comes from using the right **design patterns**. These patterns help you build infrastructure that is reusable, maintainable, testable, and aligned with enterprise standards.

This chapter explores the most important module design patterns used in real-world Terraform deployments, from simple composition to complex multi-layer architectures.

---

## 18.1 Why Module Design Patterns Matter

Good module design enables:

- Reuse across environments  
- Consistency across teams  
- Predictable deployments  
- Easier testing  
- Faster onboarding  
- Reduced duplication  
- Clear separation of concerns  

Poor module design leads to:

- Tight coupling  
- Hard-to-maintain code  
- Difficult upgrades  
- Fragile deployments  
- Bloated modules  

---

## 18.2 Pattern 1 — The “Thin Root, Thick Module” Pattern

This is the most widely recommended pattern.

### 18.2.1 Concept

- Root modules contain **only orchestration**  
- Child modules contain **all logic**  

### 18.2.2 Example

**Root module:**

```hcl
module "network" {
  source = "../../modules/network"
  location = var.location
}
```

**Child module:**

Contains all resources, locals, validation, naming, etc.

### 18.2.3 Benefits

- Clean root modules  
- Reusable modules  
- Easier testing  
- Clear separation of concerns  

---

## 18.3 Pattern 2 — Composition (Modules Calling Modules)

Modules can call other modules to build higher-level abstractions.

### 18.3.1 Example

```
module "network" → module "subnets" → module "nsg"
```

### 18.3.2 Benefits

- Highly modular  
- Easy to extend  
- Easy to test  
- Clear boundaries  

### 18.3.3 When to Use

- Complex infrastructure  
- Multi-team environments  
- Large-scale deployments  

---

## 18.4 Pattern 3 — Layered Architecture

A common enterprise pattern:

```
Layer 0 — Identity (AAD, IAM)
Layer 1 — Networking (VNet, VPC)
Layer 2 — Security (NSGs, firewalls)
Layer 3 — Compute (VMs, AKS, ECS)
Layer 4 — Platform (Databases, Storage)
Layer 5 — Applications
```

Each layer:

- Has its own root module  
- Has its own state  
- Has its own pipeline  
- Depends only on lower layers  

### 18.4.1 Benefits

- Clear separation of responsibilities  
- Safe deployments  
- Predictable dependencies  
- Easier troubleshooting  

---

## 18.5 Pattern 4 — Environment-Specific Root Modules

Each environment has its own root module:

```
environments/
  dev/
  test/
  prod/
```

Each environment:

- Uses the same modules  
- Has different variables  
- Has different backends  
- Has different pipelines  

### 18.5.1 Benefits

- True isolation  
- Safe production deployments  
- Easy environment promotion  

---

## 18.6 Pattern 5 — The “Interface Module” Pattern

An interface module wraps multiple modules into a single abstraction.

### 18.6.1 Example

```
module "application" {
  source = "./modules/application"
}
```

Inside:

- Calls network module  
- Calls compute module  
- Calls monitoring module  

### 18.6.2 Benefits

- Simplifies consumption  
- Reduces complexity for users  
- Provides a stable interface  

---

## 18.7 Pattern 6 — The “Factory Module” Pattern

A factory module creates multiple resources based on input objects.

### 18.7.1 Example

```hcl
variable "subnets" {
  type = list(object({
    name           = string
    address_prefix = string
  }))
}
```

Module loops:

```hcl
resource "azurerm_subnet" "subnet" {
  for_each = { for s in var.subnets : s.name => s }
  name     = each.value.name
}
```

### 18.7.2 Benefits

- Highly scalable  
- Declarative  
- Easy to extend  

---

## 18.8 Pattern 7 — The “Zero-Input Module” Pattern

A module that requires no inputs.

### 18.8.1 Example

A module that creates:

- Resource group  
- Naming conventions  
- Tags  

### 18.8.2 Benefits

- Easy to use  
- Enforces standards  
- Reduces user error  

---

## 18.9 Pattern 8 — The “Opinionated Module” Pattern

A module that enforces strict standards.

### 18.9.1 Example

A module that:

- Forces naming conventions  
- Forces tagging  
- Forces diagnostics  
- Forces security rules  

### 18.9.2 Benefits

- Governance  
- Compliance  
- Standardization  

---

## 18.10 Pattern 9 — The “Unopinionated Module” Pattern

A flexible module that exposes many inputs.

### 18.10.1 Example

A VNet module that allows:

- Custom address spaces  
- Custom subnets  
- Custom DNS  
- Custom tags  

### 18.10.2 Benefits

- Flexibility  
- Broad applicability  

---

## 18.11 Pattern 10 — The “Wrapper Module” Pattern

A wrapper module adds additional logic around a third-party module.

### 18.11.1 Example

Wrapping a registry module:

```
module "vnet" {
  source = "Azure/vnet/azurerm"
}
```

Wrapper adds:

- Naming conventions  
- Tags  
- Diagnostics  
- Logging  

---

## 18.12 Pattern 11 — The “Split Module” Pattern

Split a large module into smaller modules.

### 18.12.1 Example

Instead of:

```
network-module/
  vnet
  subnets
  nsg
  routes
```

Split into:

```
vnet-module/
subnet-module/
nsg-module/
route-module/
```

### 18.12.2 Benefits

- Easier testing  
- Easier upgrades  
- Better readability  

---

## 18.13 Pattern 12 — The “Global Module” Pattern

A module used across all environments.

### 18.13.1 Example

- Logging  
- Monitoring  
- Naming conventions  
- Tags  

### 18.13.2 Benefits

- Consistency  
- Governance  
- Reduced duplication  

---

## 18.14 Choosing the Right Pattern

### Use Composition When:
- You want modularity  
- You want testability  

### Use Layered Architecture When:
- You have multiple teams  
- You need strict separation  

### Use Factory Modules When:
- You need scalable resource creation  

### Use Interface Modules When:
- You want to simplify consumption  

### Use Opinionated Modules When:
- You need governance  

---

## 18.15 Summary

Module design patterns are essential for building scalable, maintainable, and enterprise-ready Terraform architectures.  
Key takeaways:

- Use thin root modules and thick child modules  
- Use composition for modularity  
- Use layered architecture for large organizations  
- Use factory modules for scalable resource creation  
- Use interface modules to simplify consumption  
- Use opinionated modules for governance  
- Avoid monolithic modules  

In the next chapter, we will explore **Module Testing and Validation**, including Terratest, tflint, and automated CI/CD validation workflows.
