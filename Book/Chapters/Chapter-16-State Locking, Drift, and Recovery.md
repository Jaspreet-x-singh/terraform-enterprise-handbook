# Chapter 16  
## State Locking, Drift, and Recovery

Terraform’s state system is powerful, but with that power comes responsibility. When multiple engineers, pipelines, or automation systems interact with the same state file, the risk of corruption, race conditions, and drift increases. Terraform provides mechanisms to prevent these issues — state locking, drift detection, and recovery workflows.

This chapter explores how these mechanisms work, how to use them effectively, and how to design resilient infrastructure workflows that avoid state-related failures.

---

## 16.1 What Is State Locking?

State locking prevents multiple concurrent operations from modifying the same state file.

Terraform locks state during:

- `terraform plan` (in some backends)  
- `terraform apply`  
- `terraform destroy`  
- `terraform refresh`  
- State manipulation commands  

Without locking, two users could:

- Apply conflicting changes  
- Overwrite each other’s updates  
- Corrupt the state file  

---

## 16.2 How State Locking Works

When Terraform begins an operation, it requests a lock from the backend.

### 16.2.1 If the Lock Is Granted  
Terraform proceeds normally.

### 16.2.2 If the Lock Is Denied  
Terraform shows:

```
Error: Error acquiring the state lock
```

This prevents unsafe operations.

---

## 16.3 Backends That Support Locking

| Backend | Locking Supported | Notes |
|---------|-------------------|-------|
| Azure Storage | Yes | Uses blob leases |
| AWS S3 | Yes | Requires DynamoDB |
| GCS | Yes | Uses object locks |
| Terraform Cloud | Yes | Built-in |
| Consul | Yes | Native locking |
| Local | No | Unsafe for teams |

---

## 16.4 Azure Storage Locking

Azure uses **blob leases** for locking.

When Terraform locks state:

- A lease is acquired on the blob  
- Other operations cannot modify it  
- The lease expires after a timeout  

If a pipeline crashes, the lease eventually expires.

---

## 16.5 AWS S3 Locking with DynamoDB

AWS requires a DynamoDB table for locking.

Example:

```hcl
dynamodb_table = "tfstate-lock"
```

The table must have:

- Partition key: `LockID`  
- Billing mode: Pay-per-request  

Terraform writes a lock record during operations.

---

## 16.6 GCS Locking

GCS uses object generation numbers to enforce locking.

Terraform ensures:

- Only one writer at a time  
- Writes fail if generation changes  

---

## 16.7 Terraform Cloud Locking

Terraform Cloud provides:

- Automatic locking  
- Automatic unlocking  
- Lock override (with permissions)  
- Audit logs  

This is the most user-friendly locking system.

---

## 16.8 Manual Locking and Unlocking

Terraform supports manual locking:

```bash
terraform force-unlock <LOCK_ID>
```

Use only when:

- A pipeline crashed  
- A lock is stuck  
- A lease expired but Terraform didn’t detect it  

Never use force-unlock during an active apply.

---

## 16.9 What Is Drift?

Drift occurs when infrastructure changes outside Terraform.

Examples:

- A VM is resized manually  
- A subnet is deleted in the portal  
- A tag is modified by another tool  
- A firewall rule is added manually  

Drift causes:

- Inaccurate plans  
- Failed applies  
- Unexpected replacements  
- Security gaps  

---

## 16.10 How Terraform Detects Drift

Terraform detects drift during:

- `terraform plan`  
- `terraform apply`  
- `terraform refresh`  

Terraform compares:

- Desired state (configuration)  
- Actual state (state file)  
- Real infrastructure (provider refresh)  

Example drift:

```
~ azurerm_subnet.subnet
    address_prefix: "10.0.1.0/24" → "10.0.2.0/24"
```

---

## 16.11 Handling Drift

### 16.11.1 Option 1 — Accept Terraform’s Changes  
Terraform will revert infrastructure to match configuration.

### 16.11.2 Option 2 — Update Configuration  
Modify `.tf` files to match real infrastructure.

### 16.11.3 Option 3 — Ignore Drift  
Use lifecycle rules:

```hcl
lifecycle {
  ignore_changes = [tags]
}
```

Use sparingly.

---

## 16.12 Preventing Drift

### 16.12.1 Enforce IaC-Only Changes  
Block manual portal changes.

### 16.12.2 Use Policy as Code  
OPA, Sentinel, Azure Policy.

### 16.12.3 Use CI/CD Pipelines  
Automate all deployments.

### 16.12.4 Use Role-Based Access Control  
Restrict portal access.

### 16.12.5 Use Monitoring  
Detect manual changes.

---

## 16.13 State Corruption

State corruption can occur due to:

- Interrupted apply  
- Backend outage  
- Manual edits  
- Merge conflicts  
- Race conditions  
- Incorrect force-unlock  

Symptoms:

- Missing resources  
- Invalid JSON  
- Apply failures  
- Drift that cannot be resolved  

---

## 16.14 Recovering from State Corruption

### 16.14.1 Option 1 — Restore from Backup  
Terraform creates:

```
terraform.tfstate.backup
```

Remote backends also support versioning.

### 16.14.2 Option 2 — Restore from Backend Versioning  
Azure Storage, S3, and GCS all support version history.

### 16.14.3 Option 3 — Rebuild State with Import  
Slow but reliable.

Steps:

1. Delete corrupted state  
2. Recreate empty state  
3. Import each resource manually  
4. Validate configuration  

### 16.14.4 Option 4 — Recreate Infrastructure  
Last resort.

---

## 16.15 State Refactoring

State refactoring is needed when:

- Splitting modules  
- Renaming resources  
- Moving resources between modules  
- Changing resource addresses  

Use:

```bash
terraform state mv <old> <new>
```

Example:

```bash
terraform state mv azurerm_subnet.subnet module.network.azurerm_subnet.subnet
```

---

## 16.16 Best Practices for Locking, Drift, and Recovery

### 16.16.1 Always Use Remote State  
Local state is unsafe.

### 16.16.2 Enable Locking  
Prevents corruption.

### 16.16.3 Avoid Manual Portal Changes  
Use IaC-only workflows.

### 16.16.4 Enable Versioning  
Allows rollback.

### 16.16.5 Use OIDC Authentication  
Eliminates long-lived credentials.

### 16.16.6 Use State Manipulation Commands Carefully  
Never edit state manually.

### 16.16.7 Document Recovery Procedures  
Teams must know how to respond.

---

## 16.17 Summary

State locking, drift detection, and recovery are essential for safe Terraform operations.  
Key takeaways:

- Locking prevents concurrent modifications  
- Drift occurs when infrastructure changes outside Terraform  
- Recovery requires backups, versioning, or imports  
- State corruption can be avoided with proper workflows  
- Remote state + CI/CD + RBAC = safe Terraform  

In the next chapter, we will explore **Terraform Modules**, the foundation of scalable, reusable infrastructure design.

