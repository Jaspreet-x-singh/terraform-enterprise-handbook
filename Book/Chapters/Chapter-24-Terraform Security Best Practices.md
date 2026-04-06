# Chapter 24  
## Terraform Security Best Practices

Security is not optional in modern infrastructure — it is foundational. Terraform, when used correctly, can enforce strong security across cloud environments. But when used incorrectly, it can expose secrets, misconfigure resources, and create vulnerabilities that attackers can exploit.

This chapter provides a comprehensive guide to Terraform security best practices, covering identity, secrets, encryption, network security, CI/CD hardening, and secure module design.

---

## 24.1 Why Terraform Security Matters

Terraform has the power to:

- Create networks  
- Open ports  
- Deploy VMs  
- Configure firewalls  
- Manage identities  
- Store secrets  
- Provision databases  

A single misconfiguration can:

- Expose data  
- Create attack surfaces  
- Break compliance  
- Cause outages  
- Lead to breaches  

Security must be built into every layer of Terraform usage.

---

## 24.2 Identity and Access Management (IAM)

### 24.2.1 Principle of Least Privilege

Terraform should only have the permissions it needs.

Examples:

- Use **Contributor** instead of **Owner** in Azure  
- Use **IAM roles** with minimal policies in AWS  
- Use **custom roles** in GCP  

### 24.2.2 Use Managed Identities / Workload Identity

Avoid long-lived credentials.

Examples:

- Azure Managed Identity  
- AWS IAM Roles for Service Accounts (IRSA)  
- GCP Workload Identity  

### 24.2.3 Use OIDC for CI/CD Authentication

OIDC eliminates:

- Client secrets  
- Key rotation  
- Secret leaks  

---

## 24.3 Secret Management

### 24.3.1 Never Store Secrets in Terraform Code

Bad:

```hcl
variable "password" {
  default = "SuperSecret123"
}
```

### 24.3.2 Never Store Secrets in tfvars

Bad:

```hcl
db_password = "SuperSecret123"
```

### 24.3.3 Use Cloud-Native Secret Managers

- Azure Key Vault  
- AWS Secrets Manager  
- GCP Secret Manager  

### 24.3.4 Use Data Sources to Retrieve Secrets

Example (Azure):

```hcl
data "azurerm_key_vault_secret" "db" {
  name         = "db-password"
  key_vault_id = azurerm_key_vault.kv.id
}
```

### 24.3.5 Mark Outputs as Sensitive

```hcl
output "password" {
  value     = data.azurerm_key_vault_secret.db.value
  sensitive = true
}
```

---

## 24.4 State File Security

Terraform state may contain:

- Passwords  
- Keys  
- Connection strings  
- Certificates  

### 24.4.1 Always Use Remote State

Avoid local state.

### 24.4.2 Enable Encryption at Rest

- Azure Storage encryption  
- AWS S3 + KMS  
- GCP CMEK  

### 24.4.3 Restrict Access to State

Only allow:

- Platform engineers  
- CI/CD pipelines  

### 24.4.4 Enable Versioning

Allows rollback after corruption.

### 24.4.5 Never Commit State to Git

Add to `.gitignore`:

```
terraform.tfstate
terraform.tfstate.backup
```

---

## 24.5 Network Security

### 24.5.1 Enforce Private Endpoints

Use private endpoints for:

- Storage accounts  
- Databases  
- Key Vault  
- Container registries  

### 24.5.2 Restrict Public Access

Disable:

- Public IPs  
- Public buckets  
- Public databases  

### 24.5.3 Enforce NSG and Firewall Rules

Use modules to enforce:

- Deny-all inbound  
- Allow-only-required outbound  
- Logging and diagnostics  

### 24.5.4 Use Service Endpoints or Private Links

Avoid exposing resources to the internet.

---

## 24.6 Encryption

### 24.6.1 Enable Encryption for All Resources

Examples:

- Storage accounts  
- Databases  
- Disks  
- Backups  

### 24.6.2 Use Customer-Managed Keys (CMK)

Use:

- Azure Key Vault keys  
- AWS KMS keys  
- GCP KMS keys  

### 24.6.3 Enforce Encryption via Policy

Use:

- Azure Policy  
- AWS Config  
- GCP Org Policies  

---

## 24.7 Secure Module Design

### 24.7.1 Enforce Naming Conventions

Use locals:

```hcl
locals {
  name = "${var.prefix}-${var.environment}-${var.component}"
}
```

### 24.7.2 Enforce Tagging

Require:

- Owner  
- Cost center  
- Environment  
- Application  

### 24.7.3 Enforce Diagnostics

Enable:

- Log Analytics  
- Storage logs  
- Activity logs  

### 24.7.4 Validate Inputs

Example:

```hcl
validation {
  condition     = contains(["dev", "test", "prod"], var.environment)
  error_message = "Invalid environment."
}
```

### 24.7.5 Avoid Exposing Secrets in Outputs

Never output:

- Passwords  
- Keys  
- Tokens  

---

## 24.8 CI/CD Pipeline Security

### 24.8.1 Use OIDC Authentication

Avoid storing secrets in pipelines.

### 24.8.2 Restrict Pipeline Permissions

Use:

- Least privilege  
- Scoped identities  
- Environment protections  

### 24.8.3 Use Approval Gates

Required for:

- Production  
- Sensitive resources  

### 24.8.4 Use Security Scanning

Tools:

- Checkov  
- tfsec  
- TFLint  

### 24.8.5 Use Plan Files

Prevents drift between plan and apply.

---

## 24.9 Policy as Code for Security

Use:

- Sentinel  
- OPA  
- Azure Policy  
- AWS Config  
- GCP Org Policies  

Enforce:

- Encryption  
- Tagging  
- Naming  
- Region restrictions  
- SKU restrictions  

---

## 24.10 Drift Detection

Nightly drift detection:

```bash
terraform plan -detailed-exitcode
```

Alerts for:

- Manual portal changes  
- Security misconfigurations  
- Unexpected resource changes  

---

## 24.11 Logging and Monitoring

Terraform should enforce:

- Diagnostic settings  
- Activity logs  
- Network flow logs  
- Key Vault logs  
- Storage logs  

Monitoring ensures:

- Visibility  
- Auditability  
- Threat detection  

---

## 24.12 Common Security Anti‑Patterns

### 24.12.1 Storing Secrets in Code  
Never acceptable.

### 24.12.2 Using Owner Permissions  
Too much power.

### 24.12.3 Using Local State  
Risky and fragile.

### 24.12.4 Allowing Public Access  
Creates attack surfaces.

### 24.12.5 No Policy Enforcement  
Leads to insecure deployments.

### 24.12.6 Manual Portal Changes  
Creates drift and vulnerabilities.

---

## 24.13 Best Practices Summary

### Identity  
- Use OIDC  
- Use least privilege  
- Use managed identities  

### Secrets  
- Use secret managers  
- Never store secrets in code  
- Mark outputs as sensitive  

### State  
- Use remote state  
- Enable encryption  
- Restrict access  

### Network  
- Use private endpoints  
- Restrict public access  
- Enforce NSGs and firewalls  

### Modules  
- Enforce naming  
- Enforce tagging  
- Validate inputs  
- Avoid exposing secrets  

### CI/CD  
- Use approval gates  
- Use security scanning  
- Use plan files  

### Governance  
- Use Policy as Code  
- Use drift detection  
- Use platform policies  

---

## 24.14 Summary

Terraform security is not a single feature — it is a mindset and a discipline.  
Key takeaways:

- Identity must follow least privilege  
- Secrets must never be stored in code or state  
- State must be encrypted and access-controlled  
- Network security must be enforced through modules  
- CI/CD must be hardened with OIDC and approvals  
- Policy as Code must enforce compliance  
- Drift detection must prevent silent failures  

In the next chapter, we will explore **Terraform Cost Optimization**, including tagging, resource sizing, lifecycle policies, and automated cost controls.
