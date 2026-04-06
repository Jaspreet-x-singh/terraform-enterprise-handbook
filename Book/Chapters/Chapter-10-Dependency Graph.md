# Chapter 10  
## Dependency Graphs

Terraform’s dependency graph is one of its most powerful and misunderstood features. It is the engine that determines the order in which resources are created, updated, and destroyed. Understanding how Terraform builds and uses this graph is essential for writing predictable, safe, and efficient infrastructure code.

This chapter explores how dependency graphs work, how Terraform infers dependencies, how to control them, and how to troubleshoot dependency-related issues.

---

## 10.1 What Is a Dependency Graph?

A dependency graph is a directed acyclic graph (DAG) that Terraform builds to understand:

- Which resources depend on which  
- The correct order of operations  
- Which resources can be created in parallel  
- Which resources must wait for others  
- How to safely update or destroy resources  

Terraform uses this graph during:

- `plan`  
- `apply`  
- `destroy`  

The graph ensures that Terraform never creates or deletes resources in an unsafe order.

---

## 10.2 How Terraform Builds the Dependency Graph

Terraform analyzes your configuration to determine dependencies using:

### 10.2.1 Implicit Dependencies  
These are inferred automatically when one resource references another.

Example:

```hcl
resource "azurerm_virtual_network" "vnet" {
  name = "vnet-app"
}

resource "azurerm_subnet" "subnet" {
  name                 = "subnet-app"
  virtual_network_name = azurerm_virtual_network.vnet.name
}
```

Terraform sees the reference:

```
azurerm_subnet.subnet → azurerm_virtual_network.vnet
```

This creates an implicit dependency.

---

### 10.2.2 Explicit Dependencies  
Use `depends_on` when Terraform cannot infer dependencies automatically.

Example:

```hcl
resource "null_resource" "wait" {
  depends_on = [
    azurerm_virtual_network.vnet,
    azurerm_subnet.subnet
  ]
}
```

Explicit dependencies are useful when:

- Using provisioners  
- Using external systems  
- Using modules that don’t expose attributes  
- Working with resources that have no direct references  

---

### 10.2.3 Module Dependencies  
Modules inherit dependencies from their internal resources.

Example:

```hcl
module "network" {
  source = "./modules/network"
}

module "compute" {
  source     = "./modules/compute"
  vnet_id    = module.network.vnet_id
}
```

Terraform infers:

```
module.compute → module.network
```

---

## 10.3 Visualizing the Dependency Graph

Terraform can render the graph:

```bash
terraform graph
```

This outputs DOT format, which can be visualized using tools like Graphviz.

Example:

```
digraph {
  "azurerm_resource_group.rg"
  "azurerm_virtual_network.vnet" -> "azurerm_resource_group.rg"
  "azurerm_subnet.subnet" -> "azurerm_virtual_network.vnet"
}
```

This helps debug complex configurations.

---

## 10.4 Parallelism and Performance

Terraform uses the dependency graph to determine which resources can be created in parallel.

Example:

```
resource A → resource B → resource C
resource D → resource E
```

Terraform can create:

- A and D in parallel  
- Then B and E in parallel  
- Then C  

Parallelism improves performance significantly in large deployments.

---

## 10.5 Dependency Graph and Resource Replacement

When a resource must be replaced, Terraform uses the graph to determine:

- What depends on it  
- What must be recreated  
- Whether replacement is safe  

Example:

```
-/+ azurerm_virtual_network.vnet (replace)
```

Terraform will:

- Create the new VNet  
- Recreate all dependent subnets  
- Recreate all dependent NICs  
- Recreate all dependent VMs  

Understanding this helps avoid accidental large-scale replacements.

---

## 10.6 Common Dependency Pitfalls

### 10.6.1 Missing Dependencies  
Terraform may attempt to create resources too early.

Fix: Add explicit `depends_on`.

---

### 10.6.2 Circular Dependencies  
Terraform cannot build a graph if cycles exist.

Example:

```
resource A depends on B  
resource B depends on A  
```

Fix: Remove unnecessary references.

---

### 10.6.3 Overusing `depends_on`  
Too many explicit dependencies reduce parallelism.

Use only when necessary.

---

### 10.6.4 Incorrect Module Outputs  
If a module doesn’t expose required attributes, Terraform cannot infer dependencies.

Fix: Add outputs.

---

## 10.7 Dependency Graph in Destroy Operations

Destroy operations reverse the dependency graph.

Example:

```
VM → NIC → Subnet → VNet → Resource Group
```

Terraform destroys:

1. VM  
2. NIC  
3. Subnet  
4. VNet  
5. Resource Group  

This ensures safe teardown.

---

## 10.8 Dependency Graph and Drift

If infrastructure changes outside Terraform:

- Terraform refreshes state  
- Compares with configuration  
- Updates the dependency graph  
- Highlights drift in the plan  

Example drift:

```
~ azurerm_subnet.subnet
    address_prefix: "10.0.1.0/24" → "10.0.2.0/24"
```

---

## 10.9 Best Practices for Dependency Management

### 10.9.1 Use Implicit Dependencies Whenever Possible  
Let Terraform infer relationships.

### 10.9.2 Use Explicit Dependencies Sparingly  
Only when Terraform cannot infer them.

### 10.9.3 Avoid Circular Dependencies  
Refactor modules if needed.

### 10.9.4 Use Outputs for Module Dependencies  
Expose all required attributes.

### 10.9.5 Keep Modules Small and Focused  
Large modules create complex graphs.

---

## 10.10 Summary

Terraform’s dependency graph is the foundation of its safe and predictable execution model.  
Key takeaways:

- Terraform builds a directed acyclic graph (DAG)  
- Implicit dependencies are inferred from references  
- Explicit dependencies are used when needed  
- The graph determines execution order and parallelism  
- Destroy operations reverse the graph  
- Understanding the graph helps avoid accidental replacements  

In the next chapter, we will explore **expressions, functions, and dynamic blocks**, which enable advanced logic in Terraform configurations.
