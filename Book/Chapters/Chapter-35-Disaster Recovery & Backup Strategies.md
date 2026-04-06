# Chapter 35  
## Disaster Recovery & Backup Strategies

Terraform is a powerful orchestration tool, but like any system that manages critical infrastructure, it must be protected against failures, corruption, accidental deletions, and operational mistakes. Disaster Recovery (DR) for Terraform focuses primarily on **state protection**, **pipeline resilience**, **module integrity**, and **environment recoverability**.

This chapter explores how to design robust DR strategies for Terraform, including state backups, recovery workflows, high‑availability patterns, and operational safeguards.

---

## 35.1 What Disaster Recovery Means for Terraform

Terraform DR focuses on four pillars:

### 35.1.1 State Recovery  
The ability to restore Terraform state after corruption, deletion, or accidental modification.

### 35.1.2 Code Recovery  
The ability to restore modules, root modules, and pipelines.

### 35.1.3 Environment Recovery  
The ability to rebuild infrastructure from scratch using Terraform.

### 35.1.4 Operational Continuity  
Ensuring Terraform workflows continue during outages.

---

## 35.2 Why Terraform State Is Critical

Terraform state contains:

- Resource IDs  
- Dependencies  
- Metadata  
- Outputs  
- Sensitive values (sometimes)  

Without state:

- Terraform cannot track resources  
- Terraform cannot detect drift  
- Terraform may recreate resources  
- Terraform may destroy resources incorrectly  

State is the single most important asset to protect.

---

## 35.3 State Backup Strategies

### 35.3.1 Remote State Backends (Mandatory)

Use:

- Azure Storage  
- AWS S3 + DynamoDB  
- GCP GCS  

Benefits:

- Automatic locking  
- Versioning  
- Encryption  
- High availability  

### 35.3.2 Enable Versioning

Examples:

- Azure Storage: Blob versioning  
- AWS S3: Versioning + MFA delete  
- GCP GCS: Object versioning  

Versioning allows:

- Rollback  
- Recovery from corruption  
- Recovery from accidental deletion  

### 35.3.3 Immutable Backups

Store periodic snapshots in:

- Backup storage accounts  
- Glacier / Archive tiers  
- Offline storage  

---

## 35.4 State Recovery Workflow

A safe recovery workflow:

### 35.4.1 Step 1 — Identify the Issue  
Examples:

- Corrupted state  
- Missing resources  
- Accidental deletion  
- Failed merge  

### 35.4.2 Step 2 — Lock the Workspace  
Prevent further changes.

### 35.4.3 Step 3 — Restore Previous Version  
Use backend versioning.

### 35.4.4 Step 4 — Validate with `terraform plan`  
Ensure no unintended changes.

### 35.4.5 Step 5 — Rebuild Missing State (If Needed)  
Use:

```bash
terraform import
```

### 35.4.6 Step 6 — Unlock and Resume Operations  

---

## 35.5 Protecting Terraform Code

### 35.5.1 Use Git as the Source of Truth  
All modules and root modules must be version-controlled.

### 35.5.2 Use Branch Protection  
Prevent accidental merges.

### 35.5.3 Use Release Tags for Modules  
Supports rollback.

### 35.5.4 Use CI/CD Validation  
Prevents broken code from reaching production.

---

## 35.6 Protecting CI/CD Pipelines

### 35.6.1 Store Pipelines in Git  
Pipelines must be version-controlled.

### 35.6.2 Use Pipeline Templates  
Ensures consistency.

### 35.6.3 Use OIDC Authentication  
Avoids secret leaks.

### 35.6.4 Use Pipeline Backups  
Export pipeline definitions periodically.

---

## 35.7 Environment Recovery Strategies

### 35.7.1 Full Rebuild from Terraform  
A well-designed Terraform architecture allows:

- Rebuilding entire environments  
- Rebuilding modules  
- Rebuilding networks  
- Rebuilding monitoring  

### 35.7.2 Rebuild Order  
Typical order:

1. Resource groups / projects  
2. Networking  
3. Identity  
4. Storage  
5. Compute  
6. Databases  
7. Monitoring  
8. Application layers  

### 35.7.3 Use Dependency Diagrams  
Document module dependencies.

---

## 35.8 High Availability for Terraform Workflows

### 35.8.1 Terraform Cloud / Enterprise  
Provides:

- HA state storage  
- HA execution  
- HA policy enforcement  

### 35.8.2 Self-Hosted Backends  
Use:

- Redundant storage accounts  
- Multi-region replication  
- DynamoDB global tables  

### 35.8.3 CI/CD HA  
Use:

- Multiple runners  
- Multiple agents  
- Backup pipelines  

---

## 35.9 Protecting Against Human Error

### 35.9.1 Use Approval Gates  
Prevents accidental applies.

### 35.9.2 Use Plan Files  
Ensures apply uses reviewed plan.

### 35.9.3 Use Policy as Code  
Prevents destructive changes.

### 35.9.4 Use Drift Detection  
Detects manual portal changes.

### 35.9.5 Use Safe Destroy Workflows  
Require:

- Manual trigger  
- Confirmation  
- Approval  

---

## 35.10 Protecting Against Provider Issues

Cloud providers sometimes:

- Change APIs  
- Introduce breaking changes  
- Deprecate SKUs  
- Modify defaults  

### 35.10.1 Pin Provider Versions  
Avoid unexpected behavior.

### 35.10.2 Use Provider Changelogs  
Review before upgrading.

### 35.10.3 Test in Lower Environments  
Never upgrade directly in prod.

---

## 35.11 Protecting Against Drift

### 35.11.1 Nightly Drift Detection  
Use:

```bash
terraform plan -detailed-exitcode
```

### 35.11.2 Drift Alerts  
Send to:

- Teams  
- Slack  
- Email  

### 35.11.3 Drift Remediation  
Fix drift before applying changes.

---

## 35.12 Disaster Recovery Testing

### 35.12.1 Test State Recovery  
Simulate:

- Corruption  
- Deletion  
- Rollback  

### 35.12.2 Test Environment Rebuild  
Rebuild dev environment from scratch.

### 35.12.3 Test Pipeline Recovery  
Restore pipelines from Git.

### 35.12.4 Test Module Rollback  
Rollback to previous version.

---

## 35.13 Anti-Patterns

### 35.13.1 Local State  
Never use local state in production.

### 35.13.2 No Versioning  
Impossible to recover.

### 35.13.3 No Approval Gates  
Risky.

### 35.13.4 No Drift Detection  
Leads to surprises.

### 35.13.5 No Documentation  
Slows recovery.

---

## 35.14 Best Practices Summary

### State  
- Use remote state  
- Enable versioning  
- Use immutable backups  
- Test recovery  

### Code  
- Use Git  
- Use tags  
- Use CI/CD  

### Pipelines  
- Use templates  
- Use OIDC  
- Use backups  

### Environments  
- Use rebuildable architecture  
- Use dependency diagrams  

### Governance  
- Use policy as code  
- Use approval gates  
- Use drift detection  

---

## 35.15 Summary

Disaster Recovery for Terraform is not optional — it is essential for operational resilience.  
Key takeaways:

- State is the most critical asset to protect  
- Use remote state with versioning and backups  
- Use Git for code and pipeline recovery  
- Use CI/CD and governance to prevent human error  
- Use drift detection to catch manual changes  
- Test recovery regularly  
- Design environments to be fully rebuildable  

In the next chapter, we will explore **Terraform Performance Optimization**, including plan/apply performance, provider tuning, module optimization, and large-scale environment strategies.

