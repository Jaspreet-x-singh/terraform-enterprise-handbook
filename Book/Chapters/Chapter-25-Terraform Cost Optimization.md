# Chapter 25  
## Terraform Cost Optimization

Infrastructure-as-code gives you the power to deploy resources at scale — but with that power comes the responsibility to control cost. Terraform can be a powerful ally in cost optimization when used with the right patterns, guardrails, and automation.

This chapter explores how to design Terraform configurations that minimize waste, enforce cost controls, and provide visibility into cloud spending across environments.

---

## 25.1 Why Cost Optimization Matters

Cloud costs can spiral quickly due to:

- Overprovisioned resources  
- Forgotten test environments  
- Unused disks or IPs  
- Public-facing services left running  
- Lack of tagging and ownership  
- Manual deployments without governance  

Terraform helps prevent these issues by:

- Enforcing standards  
- Automating cleanup  
- Enabling right-sizing  
- Providing visibility  
- Integrating with cost tools  

---

## 25.2 Cost Optimization Principles

### 25.2.1 Right-Sizing  
Choose the smallest SKU that meets requirements.

### 25.2.2 Elasticity  
Scale up and down automatically.

### 25.2.3 Visibility  
Tag resources for cost reporting.

### 25.2.4 Automation  
Destroy unused environments automatically.

### 25.2.5 Governance  
Prevent expensive resources unless approved.

---

## 25.3 Tagging for Cost Allocation

Tagging is the foundation of cost optimization.

### 25.3.1 Required Tags

Common tags:

- `owner`  
- `environment`  
- `cost_center`  
- `application`  
- `lifecycle`  
- `department`  

### 25.3.2 Enforcing Tags in Modules

```hcl
variable "tags" {
  type = map(string)
}

locals {
  default_tags = {
    owner       = var.owner
    environment = var.environment
  }

  merged_tags = merge(local.default_tags, var.tags)
}
```

Apply tags:

```hcl
tags = local.merged_tags
```

---

## 25.4 Right-Sizing Resources

Terraform enables right-sizing by:

- Using variables for SKUs  
- Using validation blocks  
- Using environment-specific tfvars  

### 25.4.1 Example: VM SKU Validation

```hcl
validation {
  condition     = contains(["Standard_B2s", "Standard_D2s_v3"], var.vm_size)
  error_message = "Invalid VM size."
}
```

### 25.4.2 Example: Database SKU Restrictions

```hcl
validation {
  condition     = var.environment != "dev" || var.sku == "Basic"
  error_message = "Dev must use Basic SKU."
}
```

---

## 25.5 Auto-Shutdown and Scheduling

Terraform can configure:

- Auto-shutdown for dev/test VMs  
- Scaling schedules  
- Automation runbooks  

### 25.5.1 Example: Azure Auto-Shutdown

```hcl
resource "azurerm_dev_test_global_vm_shutdown_schedule" "shutdown" {
  daily_recurrence_time = "1900"
  timezone              = "AUS Eastern Standard Time"
}
```

---

## 25.6 Lifecycle Policies

Lifecycle policies help reduce cost by:

- Automatically deleting old resources  
- Managing retention  
- Cleaning up unused artifacts  

### 25.6.1 Example: Storage Lifecycle

```hcl
resource "azurerm_storage_management_policy" "policy" {
  rule {
    name    = "cleanup"
    enabled = true

    filters {
      prefix_match = ["logs/"]
    }

    actions {
      base_blob {
        delete_after_days_since_modification_greater_than = 30
      }
    }
  }
}
```

---

## 25.7 Spot and Preemptible Instances

Terraform supports:

- Azure Spot VMs  
- AWS Spot Instances  
- GCP Preemptible VMs  

### 25.7.1 Example: Azure Spot VM

```hcl
priority        = "Spot"
eviction_policy = "Deallocate"
```

### 25.7.2 When to Use Spot

- Batch jobs  
- CI runners  
- Stateless workloads  

---

## 25.8 Reserved Instances and Savings Plans

Terraform can configure:

- Azure Reserved Instances  
- AWS Savings Plans  
- GCP Committed Use Discounts  

These reduce cost for predictable workloads.

---

## 25.9 Storage Optimization

### 25.9.1 Use Lower Tiers for Non-Critical Data

Examples:

- Hot → Cool → Archive (Azure)  
- Standard → Infrequent Access → Glacier (AWS)  

### 25.9.2 Delete Unattached Disks

Terraform can detect and remove unused disks.

### 25.9.3 Use Lifecycle Rules  
Automatically delete old logs.

---

## 25.10 Network Cost Optimization

### 25.10.1 Use Private Endpoints  
Reduces egress cost.

### 25.10.2 Avoid Unnecessary Public IPs  
Public IPs incur cost.

### 25.10.3 Use Service Endpoints  
Cheaper than public routing.

---

## 25.11 Database Cost Optimization

### 25.11.1 Use Serverless or Hyperscale  
Pay only for usage.

### 25.11.2 Use Auto-Pause  
Pause databases when idle.

### 25.11.3 Use Lower Tiers for Dev/Test  
Basic or free tiers.

---

## 25.12 Kubernetes Cost Optimization

### 25.12.1 Use Node Autoscaling  
Scale nodes based on demand.

### 25.12.2 Use Spot Nodes  
Reduce cost for non-critical workloads.

### 25.12.3 Use Pod Autoscaling  
Scale workloads automatically.

---

## 25.13 Cost Governance with Policy as Code

Policies can enforce:

- Allowed SKUs  
- Allowed regions  
- Required tags  
- Maximum VM sizes  
- No public IPs  
- No premium SKUs in dev  

Example OPA policy:

```rego
deny[msg] {
  input.resource.type == "azurerm_virtual_machine"
  input.resource.sku == "Premium"
  input.resource.environment != "prod"
  msg = "Premium SKU allowed only in prod."
}
```

---

## 25.14 Cost Visibility and Reporting

Terraform integrates with:

- Azure Cost Management  
- AWS Cost Explorer  
- GCP Billing Reports  
- Third-party tools (CloudHealth, Cloudability)  

Tagging enables:

- Chargeback  
- Showback  
- Department-level reporting  

---

## 25.15 Automated Cleanup Workflows

Terraform can integrate with:

- Azure Automation  
- AWS Lambda  
- GCP Cloud Functions  

Use cases:

- Delete old snapshots  
- Delete unused IPs  
- Delete orphaned disks  
- Delete expired environments  

---

## 25.16 Cost Optimization Anti-Patterns

### 25.16.1 Overprovisioning  
Choosing large SKUs “just in case.”

### 25.16.2 No Tagging  
Impossible to track cost.

### 25.16.3 No Auto-Shutdown  
Dev/test environments run 24/7.

### 25.16.4 No Lifecycle Policies  
Storage grows endlessly.

### 25.16.5 No Policy Enforcement  
Teams deploy expensive resources freely.

---

## 25.17 Best Practices Summary

### Tagging  
- Enforce required tags  
- Use tagging modules  

### Right-Sizing  
- Use validation  
- Use environment-specific SKUs  

### Automation  
- Auto-shutdown  
- Lifecycle policies  
- Cleanup workflows  

### Governance  
- Policy as Code  
- Approval gates  

### Visibility  
- Cost dashboards  
- Chargeback models  

---

## 25.18 Summary

Terraform can be a powerful tool for cost optimization when used with the right patterns and governance.  
Key takeaways:

- Tagging is essential for cost visibility  
- Right-sizing prevents waste  
- Auto-shutdown and lifecycle policies reduce cost  
- Spot instances provide massive savings  
- Policy as Code enforces cost controls  
- Automation prevents forgotten resources  
- Cost dashboards provide visibility  

In the next chapter, we will explore **Terraform Monitoring and Observability**, including diagnostics, logging, metrics, and alerting.
