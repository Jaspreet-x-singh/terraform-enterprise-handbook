# Chapter 34  
## Migration Strategies

Migrating to Terraform is one of the most impactful steps an organization can take toward modern, automated, and scalable infrastructure management. But migration is rarely simple — existing environments may contain years of manually created resources, legacy IaC tools, inconsistent naming, and undocumented dependencies.

This chapter provides a comprehensive guide to migrating from:

- Manual cloud resources  
- ARM templates  
- Bicep  
- AWS CloudFormation  
- GCP Deployment Manager  
- Legacy Terraform codebases  
- Multi-environment sprawl  
- Multi-subscription or multi-account architectures  

We’ll explore patterns, pitfalls, and step-by-step strategies for safe, predictable migrations.

---

## 34.1 Why Migrate to Terraform?

Organizations migrate to Terraform to achieve:

- **Consistency** — predictable, repeatable deployments  
- **Automation** — CI/CD-driven infrastructure  
- **Governance** — policy enforcement and compliance  
- **Scalability** — multi-team, multi-environment workflows  
- **Visibility** — version control and auditability  
- **Portability** — multi-cloud support  

Terraform becomes the foundation for modern infrastructure operations.

---

## 34.2 Migration Principles

Before migrating, align on these principles:

### 34.2.1 Principle 1 — No Big Bang  
Migrate incrementally, not all at once.

### 34.2.2 Principle 2 — No Downtime  
Migration must not disrupt production.

### 34.2.3 Principle 3 — No Resource Re-Creation  
Use `terraform import` to adopt existing resources.

### 34.2.4 Principle 4 — Standardize Before Migrating  
Fix naming, tagging, and structure first.

### 34.2.5 Principle 5 — Build Modules First  
Never migrate directly into root modules.

---

## 34.3 Migration Workflow Overview

A safe migration follows this sequence:

1. **Discovery**  
2. **Inventory**  
3. **Standardization**  
4. **Module creation**  
5. **State architecture design**  
6. **Import planning**  
7. **Import execution**  
8. **Validation**  
9. **CI/CD integration**  
10. **Promotion to higher environments**  

Each step reduces risk and ensures long-term maintainability.

---

## 34.4 Migrating from Manual Cloud Resources

### 34.4.1 Step 1 — Inventory Existing Resources  
Use:

- Azure Resource Graph  
- AWS Resource Explorer  
- GCP Asset Inventory  

### 34.4.2 Step 2 — Normalize Naming and Tagging  
Fix inconsistencies before importing.

### 34.4.3 Step 3 — Build Modules  
Create modules for:

- Network  
- Compute  
- Storage  
- Databases  
- Monitoring  

### 34.4.4 Step 4 — Write Root Modules  
Root modules represent environments.

### 34.4.5 Step 5 — Import Resources  
Use:

```bash
terraform import <resource> <id>
```

### 34.4.6 Step 6 — Validate with Plan  
Ensure no drift or re-creation.

---

## 34.5 Migrating from ARM Templates

ARM templates are JSON-based and verbose.

### 34.5.1 Challenges  
- Hard to maintain  
- No module system  
- No state  
- Limited reusability  

### 34.5.2 Migration Strategy  
1. Convert ARM → Bicep (optional)  
2. Use Bicep to understand structure  
3. Build Terraform modules  
4. Import resources  
5. Validate  

### 34.5.3 ARM → Terraform Mapping  
- Parameters → Variables  
- Outputs → Outputs  
- Resources → Terraform resources  
- Nested templates → Modules  

---

## 34.6 Migrating from Bicep

Bicep is cleaner than ARM but still Azure-only.

### 34.6.1 Why Migrate from Bicep?  
- Multi-cloud needs  
- Module reusability  
- Better CI/CD integration  
- State management  

### 34.6.2 Migration Strategy  
1. Extract parameters  
2. Extract resource definitions  
3. Build Terraform modules  
4. Import resources  
5. Validate  

---

## 34.7 Migrating from AWS CloudFormation

CloudFormation is AWS-native but limited.

### 34.7.1 Challenges  
- YAML/JSON complexity  
- No cross-cloud support  
- Limited module system  

### 34.7.2 Migration Strategy  
1. Export CloudFormation stack resources  
2. Map to Terraform resources  
3. Build modules  
4. Import resources  
5. Validate  

### 34.7.3 CloudFormation → Terraform Mapping  
- Parameters → Variables  
- Outputs → Outputs  
- Nested stacks → Modules  

---

## 34.8 Migrating from GCP Deployment Manager

Deployment Manager uses YAML + Jinja/Python.

### 34.8.1 Challenges  
- Limited adoption  
- Complex templates  
- No state  

### 34.8.2 Migration Strategy  
1. Export deployment configuration  
2. Build Terraform modules  
3. Import resources  
4. Validate  

---

## 34.9 Migrating from Legacy Terraform

Legacy Terraform codebases often suffer from:

- No modules  
- Huge root modules  
- Shared state  
- Hardcoded values  
- No CI/CD  
- No validation  

### 34.9.1 Migration Strategy  
1. Refactor into modules  
2. Split state files  
3. Introduce tfvars  
4. Introduce CI/CD  
5. Introduce policy as code  
6. Introduce versioning  

---

## 34.10 Migrating Multi-Environment Architectures

### 34.10.1 Challenges  
- Inconsistent environments  
- Manual drift  
- Different naming conventions  
- Different SKUs  

### 34.10.2 Strategy  
1. Standardize naming  
2. Standardize tagging  
3. Standardize tfvars  
4. Build environment-specific root modules  
5. Import resources per environment  
6. Validate  

---

## 34.11 Migrating Multi-Subscription / Multi-Account Architectures

### 34.11.1 Challenges  
- Different identity models  
- Different networking  
- Different policies  
- Different access controls  

### 34.11.2 Strategy  
1. Build provider aliases  
2. Build cross-subscription modules  
3. Build remote state references  
4. Import resources  
5. Validate  

---

## 34.12 Importing Resources Safely

### 34.12.1 Use `terraform import`  
Import one resource at a time.

### 34.12.2 Use Import Blocks (Terraform 1.5+)  
Declarative imports:

```hcl
import {
  to = azurerm_storage_account.sa
  id = "/subscriptions/xxx/resourceGroups/rg/providers/Microsoft.Storage/storageAccounts/sa"
}
```

### 34.12.3 Validate with Plan  
Ensure no changes.

### 34.12.4 Use State Show  
Verify imported values:

```bash
terraform state show <resource>
```

---

## 34.13 Migration Anti-Patterns

### 34.13.1 Big Bang Migration  
High risk.

### 34.13.2 Recreating Resources  
Causes downtime.

### 34.13.3 Importing Without Modules  
Unmaintainable.

### 34.13.4 Importing Without Standardization  
Creates long-term chaos.

### 34.13.5 Shared State  
Dangerous.

---

## 34.14 Best Practices Summary

### Before Migration  
- Inventory resources  
- Standardize naming  
- Standardize tagging  
- Build modules  

### During Migration  
- Import incrementally  
- Validate with plan  
- Use remote state  
- Use CI/CD  

### After Migration  
- Enforce governance  
- Enforce policy as code  
- Enforce module versioning  
- Enforce drift detection  

---

## 34.15 Summary

Migrating to Terraform is a transformative process that requires planning, discipline, and a structured approach.  
Key takeaways:

- Migrate incrementally, not all at once  
- Standardize naming and tagging before importing  
- Build modules before migrating  
- Use import blocks for safe adoption  
- Validate with plan to avoid re-creation  
- Use CI/CD and governance after migration  
- Avoid anti-patterns like big bang migrations or shared state  

In the next chapter, we will explore **Terraform Disaster Recovery & Backup Strategies**, including state backup, recovery workflows, and high-availability patterns.
