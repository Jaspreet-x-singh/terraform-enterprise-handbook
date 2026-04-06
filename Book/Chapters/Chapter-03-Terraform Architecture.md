# Chapter 3  
## Terraform Architecture

Terraform’s internal architecture is one of the key reasons it has become the industry standard for Infrastructure as Code. Its design emphasizes predictability, modularity, extensibility, and safety. Understanding how Terraform works under the hood is essential for writing efficient configurations, debugging issues, and designing scalable infrastructure systems.

This chapter provides a deep dive into Terraform’s architecture, including the core engine, providers, the dependency graph, the state model, and the plan/apply lifecycle.

---

## 3.1 High-Level Architecture Overview

Terraform’s architecture consists of four major components:

1. **Core (Terraform Engine)**  
   Responsible for reading configuration, building dependency graphs, generating plans, and applying changes.

2. **Providers**  
   Plugins that interact with APIs (Azure, AWS, GCP, Kubernetes, GitHub, etc.).

3. **State**  
   A database of metadata about deployed infrastructure.

4. **Configuration Files**  
   HCL files that define desired infrastructure.

These components work together to translate declarative configuration into real-world infrastructure.

---

## 3.2 The Terraform Core Engine

The core engine is responsible for:

- Parsing HCL configuration  
- Validating syntax and structure  
- Building the dependency graph  
- Comparing desired vs actual state  
- Generating execution plans  
- Applying changes  
- Managing lifecycle rules  
- Handling drift detection  

The core engine does **not** know anything about cloud providers.  
It delegates all resource operations to providers.

---

## 3.3 Providers: Terraform’s Plugin System

Providers are the bridge between Terraform and external systems.  
Each provider:

- Implements resources  
- Implements data sources  
- Handles CRUD operations  
- Communicates with APIs  
- Manages authentication  
- Enforces validation  

### 3.3.1 Provider Structure

A provider typically includes:

- **Resources** (create/update/delete infrastructure)  
- **Data sources** (read existing infrastructure)  
- **Schemas** (define arguments and attributes)  
- **API clients** (interact with cloud platforms)  

### 3.3.2 Provider Examples

- `azurerm` → Azure  
- `aws` → Amazon Web Services  
- `google` → Google Cloud  
- `kubernetes` → Kubernetes clusters  
- `github` → GitHub repositories  
- `cloudflare` → DNS and security  

Terraform’s provider ecosystem is one of its biggest strengths.

---

## 3.4 Resources and Data Sources

### 3.4.1 Resources  
Resources represent infrastructure objects.

Example:

```hcl
resource "azurerm_storage_account" "sa" {
  name                     = "stappdata001"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
```

Terraform manages the full lifecycle of resources.

### 3.4.2 Data Sources  
Data sources query existing infrastructure.

Example:

```hcl
data "azurerm_client_config" "current" {}
```

Data sources do not create anything — they only read.

---

## 3.5 The Dependency Graph

Terraform automatically builds a dependency graph based on:

- Resource references  
- Implicit dependencies  
- Explicit `depends_on` blocks  

### 3.5.1 Why the Dependency Graph Matters

The graph determines:

- Execution order  
- Parallelism  
- Update sequencing  
- Safe deletion  
- Drift detection  

### 3.5.2 Example Dependency Graph

```
azurerm_resource_group.rg
        ↓
azurerm_virtual_network.vnet
        ↓
azurerm_subnet.subnet
        ↓
azurerm_network_interface.nic
        ↓
azurerm_linux_virtual_machine.vm
```

Terraform uses this graph to orchestrate operations safely.

---

## 3.6 The Terraform State Model

State is a critical part of Terraform’s architecture.

### 3.6.1 What State Contains

- Resource IDs  
- Attributes  
- Metadata  
- Dependencies  
- Outputs  
- Sensitive values (if not redacted)  

### 3.6.2 Why State Is Needed

Terraform uses state to:

- Understand what exists  
- Detect drift  
- Generate accurate plans  
- Prevent destructive operations  
- Track dependencies  

### 3.6.3 Local vs Remote State

| State Type | Use Case |
|------------|----------|
| Local | Small projects, testing |
| Remote | Teams, production, collaboration |

Remote state backends include:

- Azure Storage  
- AWS S3  
- Google Cloud Storage  
- Terraform Cloud  

---

## 3.7 The Plan and Apply Lifecycle

Terraform’s lifecycle consists of three major phases:

### 3.7.1 Phase 1 — Init  
Initializes providers and modules.

### 3.7.2 Phase 2 — Plan  
Terraform compares:

- Desired state (configuration)  
- Actual state (state file)  
- Real-world infrastructure (via providers)  

It then generates a plan showing:

- Additions  
- Updates  
- Deletions  

### 3.7.3 Phase 3 — Apply  
Terraform executes the plan:

- Creates resources  
- Updates resources  
- Deletes resources  
- Refreshes state  

Terraform ensures operations are safe and predictable.

---

## 3.8 Lifecycle Rules

Terraform provides lifecycle rules to control behavior:

```hcl
lifecycle {
  prevent_destroy = true
  ignore_changes  = [tags]
  create_before_destroy = true
}
```

These rules help manage:

- Zero-downtime deployments  
- Sensitive resources  
- Drift tolerance  

---

## 3.9 How Terraform Handles Drift

Drift occurs when infrastructure changes outside Terraform.

Terraform detects drift by:

- Refreshing state  
- Comparing with configuration  
- Highlighting differences in the plan  

Drift can be:

- Corrected  
- Ignored  
- Managed with lifecycle rules  

---

## 3.10 Terraform’s Execution Modes

Terraform supports:

### 3.10.1 Local Execution  
Runs on a developer’s machine.

### 3.10.2 Remote Execution  
Runs in:

- Terraform Cloud  
- Terraform Enterprise  
- CI/CD pipelines  

Remote execution improves:

- Security  
- Consistency  
- Collaboration  

---

## 3.11 Summary

Terraform’s architecture is built around:

- A powerful core engine  
- A flexible provider system  
- A robust state model  
- A dependency graph  
- A safe plan/apply workflow  

Understanding these components is essential for writing efficient, scalable, and maintainable Terraform configurations.

In the next chapter, we will explore **providers, resources, and data sources** in greater detail.
