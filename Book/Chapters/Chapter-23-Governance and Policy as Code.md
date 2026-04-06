# Chapter 23  
## Governance and Policy as Code

As organizations scale their Terraform usage, governance becomes essential. Without guardrails, teams may deploy insecure, non‑compliant, or inconsistent infrastructure. Policy as Code (PaC) provides a structured, automated way to enforce standards, security, and compliance across all Terraform deployments.

This chapter explores governance models, policy frameworks, enforcement strategies, and real-world enterprise patterns for managing Terraform at scale.

---

## 23.1 Why Governance Matters

Governance ensures:

- **Security** — prevent insecure configurations  
- **Compliance** — enforce regulatory requirements  
- **Consistency** — standardize naming, tagging, and architecture  
- **Safety** — prevent destructive or risky changes  
- **Auditability** — track who changed what and when  
- **Scalability** — support multiple teams and environments  

Without governance, Terraform becomes a liability rather than an asset.

---

## 23.2 What Is Policy as Code?

Policy as Code means writing governance rules in code, not documents.

Policies can enforce:

- Allowed regions  
- Required tags  
- Encryption requirements  
- Naming conventions  
- SKU restrictions  
- Network security rules  
- Identity and access controls  
- Resource limits  
- Cost controls  

PaC ensures policies are:

- Automated  
- Version-controlled  
- Testable  
- Reusable  
- Enforced consistently  

---

## 23.3 Policy Enforcement Models

### 23.3.1 Model 1 — Preventive (Pre‑Deployment)

Policies run during:

- Pull requests  
- Terraform plan  
- CI/CD validation  

Prevents non‑compliant code from being applied.

### 23.3.2 Model 2 — Detective (Post‑Deployment)

Policies run after deployment:

- Azure Policy  
- AWS Config  
- GCP Config Validator  

Detects drift and misconfigurations.

### 23.3.3 Model 3 — Corrective (Auto‑Remediation)

Automatically fixes issues:

- Auto-remediation scripts  
- Cloud-native remediation  
- Policy-driven enforcement  

---

## 23.4 Policy as Code Frameworks

### 23.4.1 Sentinel (Terraform Cloud / Enterprise)

Sentinel is HashiCorp’s policy engine.

Capabilities:

- Deep Terraform integration  
- Access to plan, state, and config  
- Fine-grained enforcement  
- Policy sets per workspace  

Example Sentinel rule:

```hcl
import "tfplan/v2" as tfplan

deny if tfplan.resource_changes["azurerm_storage_account"].change.after.enable_https_traffic_only is false
```

---

### 23.4.2 Open Policy Agent (OPA)

OPA is an open-source, cloud-agnostic policy engine.

Uses Rego language.

Example:

```rego
deny[msg] {
  input.resource.type == "azurerm_storage_account"
  input.resource.enable_https_traffic_only == false
  msg = "HTTPS must be enabled"
}
```

OPA integrates with:

- GitHub Actions  
- Azure DevOps  
- GitLab CI  
- Terraform Cloud (via custom workflows)  

---

### 23.4.3 Azure Policy

Azure Policy enforces compliance at the platform level.

Examples:

- Require tags  
- Enforce encryption  
- Restrict regions  
- Enforce SKU types  
- Audit insecure configurations  

Azure Policy can:

- Block deployments  
- Audit non-compliant resources  
- Auto-remediate  

---

### 23.4.4 AWS Config + Service Control Policies (SCPs)

AWS governance tools include:

- AWS Config rules  
- SCPs (organization-wide restrictions)  
- IAM permission boundaries  

Examples:

- Deny unencrypted S3 buckets  
- Restrict EC2 instance types  
- Enforce VPC usage  

---

### 23.4.5 GCP Organization Policies

GCP provides:

- Org policies  
- Config Validator  
- Forseti Security  

Examples:

- Restrict public IPs  
- Enforce CMEK  
- Restrict regions  

---

## 23.5 Governance Layers

A mature governance model includes:

### 23.5.1 Layer 1 — Code Governance  
- Code reviews  
- Linting  
- Security scanning  
- Module versioning  

### 23.5.2 Layer 2 — CI/CD Governance  
- Approval gates  
- Plan review  
- Policy checks  
- Drift detection  

### 23.5.3 Layer 3 — Platform Governance  
- Azure Policy  
- AWS Config  
- GCP Org Policies  

### 23.5.4 Layer 4 — Organizational Governance  
- RBAC  
- Identity management  
- Audit logs  
- Cost controls  

---

## 23.6 Governance in CI/CD Pipelines

A governance-enabled pipeline includes:

### 23.6.1 Step 1 — Linting

- TFLint  
- Checkov  
- tfsec  

### 23.6.2 Step 2 — Policy Checks

- OPA  
- Sentinel  
- Custom scripts  

### 23.6.3 Step 3 — Plan Review

Human review of:

- Resource creations  
- Updates  
- Deletions  
- Replacements  

### 23.6.4 Step 4 — Approval Gates

Required for:

- Production  
- Sensitive resources  
- High-risk changes  

### 23.6.5 Step 5 — Apply

Executed only after:

- Policy checks pass  
- Approvals granted  

---

## 23.7 Governance for Modules

Modules must enforce:

- Naming conventions  
- Tagging standards  
- Diagnostics  
- Security defaults  
- Required inputs  
- Validation blocks  

Example validation:

```hcl
validation {
  condition     = contains(["dev", "test", "prod"], var.environment)
  error_message = "Environment must be dev, test, or prod."
}
```

---

## 23.8 Governance for Environments

Each environment should have:

- Separate backends  
- Separate pipelines  
- Separate access controls  
- Separate policies  

Production requires:

- Strict RBAC  
- Mandatory approvals  
- Policy enforcement  
- Audit logging  

---

## 23.9 Governance Anti‑Patterns

### 23.9.1 No Policy Enforcement  
Leads to insecure deployments.

### 23.9.2 Manual Portal Changes  
Creates drift and compliance failures.

### 23.9.3 Shared State Across Environments  
Dangerous and fragile.

### 23.9.4 No Approval Gates  
Risky for production.

### 23.9.5 No Module Standards  
Inconsistent infrastructure.

---

## 23.10 Best Practices for Governance

### 23.10.1 Use Policy as Code Everywhere  
Automate compliance.

### 23.10.2 Use OIDC for Authentication  
Eliminate long-lived secrets.

### 23.10.3 Use Module Standards  
Enforce naming, tagging, diagnostics.

### 23.10.4 Use Approval Gates  
Protect production.

### 23.10.5 Use Platform Policies  
Azure Policy, AWS Config, GCP Org Policies.

### 23.10.6 Use Drift Detection  
Prevent silent failures.

### 23.10.7 Use Documentation  
Make governance understandable.

---

## 23.11 Summary

Governance and Policy as Code are essential for secure, compliant, and scalable Terraform usage.  
Key takeaways:

- Governance prevents misconfigurations and enforces standards  
- Policy as Code automates compliance  
- Sentinel, OPA, Azure Policy, AWS Config, and GCP Org Policies provide enforcement  
- Governance must exist at code, pipeline, platform, and organizational layers  
- Approval gates and drift detection protect production  
- Module standards ensure consistency  

In the next chapter, we will explore **Terraform Security Best Practices**, including identity, secrets, encryption, network security, and secure CI/CD patterns.
