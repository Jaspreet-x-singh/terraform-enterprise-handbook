# Chapter 41  
## Security Best Practices

Security is not an optional layer in Terraform — it is foundational. Terraform provisions critical infrastructure, identities, networks, secrets, and data platforms. A single misconfiguration can expose entire environments, leak sensitive data, or create compliance violations. Security must be embedded into every stage of the Terraform lifecycle: design, coding, testing, pipelines, state management, and runtime operations.

This chapter provides a comprehensive guide to Terraform security best practices across identity, secrets, encryption, networking, governance, pipelines, and state protection.

---

## 41.1 The Terraform Security Mindset

Terraform security requires:

- **Least privilege** — minimal access required  
- **Zero trust** — no implicit trust  
- **Defense in depth** — multiple layers of protection  
- **Shift left** — security early in the pipeline  
- **Automation** — enforce security continuously  
- **Auditability** — full traceability of changes  

Security must be proactive, not reactive.

---

## 41.2 Identity and Access Management (IAM)

Identity is the foundation of Terraform security.

### 41.2.1 Use Federated Identity (OIDC)

Avoid long-lived credentials. Use:

- GitHub → Azure AD  
- GitHub → AWS IAM  
- GitHub → GCP IAM  

Benefits:

- No secrets  
- Short-lived tokens  
- Strong auditability  

### 41.2.2 Use Least Privilege Roles

Terraform should only have permissions required for:

- Reading state  
- Creating resources  
- Updating resources  
- Deleting resources (if allowed)  

Avoid:

- Owner roles  
- Admin roles  
- Wildcard permissions  

### 41.2.3 Use Managed Identities (Azure)  
Use system-assigned or user-assigned identities for:

- Key Vault access  
- Storage access  
- Database access  

### 41.2.4 Use IAM Roles (AWS)  
Use:

- AssumeRole  
- Role chaining  
- Scoped permissions  

### 41.2.5 Use Service Accounts (GCP)  
Grant minimal roles.

---

## 41.3 Secret Management

Secrets must never appear in:

- Terraform code  
- tfvars files in Git  
- CI/CD logs  
- Terraform state (if avoidable)  

### 41.3.1 Use Secret Managers

Use:

- Azure Key Vault  
- AWS Secrets Manager  
- GCP Secret Manager  
- HashiCorp Vault  

### 41.3.2 Use Data Sources to Fetch Secrets

Example:

```hcl
data "azurerm_key_vault_secret" "db" {
  name         = "db-password"
  key_vault_id = var.kv_id
}
```

### 41.3.3 Mark Outputs as Sensitive

```hcl
output "password" {
  value     = data.azurerm_key_vault_secret.db.value
  sensitive = true
}
```

### 41.3.4 Avoid Storing Secrets in State  
State is not a secret store.

---

## 41.4 Encryption Best Practices

### 41.4.1 Encrypt State at Rest  
Remote backends encrypt state automatically.

### 41.4.2 Encrypt Resources  
Enforce encryption for:

- Storage accounts  
- Databases  
- Virtual machines  
- Containers  
- Logs  

### 41.4.3 Use Customer-Managed Keys (CMK/KMS/CMEK)  
For regulated workloads.

### 41.4.4 Enforce Encryption via Policy  
Use:

- Azure Policy  
- AWS Config  
- GCP Org Policies  

---

## 41.5 Network Security

### 41.5.1 Use Private Endpoints  
Avoid public exposure.

### 41.5.2 Use Network Segmentation  
Separate:

- App tier  
- Data tier  
- Management tier  

### 41.5.3 Use Firewalls and NSGs  
Enforce:

- Inbound rules  
- Outbound rules  
- Micro-segmentation  

### 41.5.4 Disable Public Access by Default  
For:

- Storage  
- Databases  
- Key Vault  
- APIs  

### 41.5.5 Use Zero-Trust Principles  
Identity-based access > network-based access.

---

## 41.6 Governance and Policy Enforcement

### 41.6.1 Use Policy as Code  
Use:

- Sentinel  
- OPA/Rego  
- Azure Policy  
- AWS Config  

### 41.6.2 Enforce Naming Standards  
Prevent resource sprawl.

### 41.6.3 Enforce Tagging Standards  
Enable:

- Cost allocation  
- Ownership  
- Compliance  

### 41.6.4 Enforce SKU Restrictions  
Prevent expensive or insecure SKUs.

### 41.6.5 Enforce Region Restrictions  
Prevent deployments in unauthorized regions.

---

## 41.7 CI/CD Pipeline Security

### 41.7.1 Use OIDC Authentication  
Avoid secrets.

### 41.7.2 Use Approval Gates  
Required for:

- Production  
- Networking  
- Identity  
- Databases  

### 41.7.3 Use Security Scanning  
Include:

- Checkov  
- tfsec  
- TFLint  
- SAST tools  

### 41.7.4 Use Plan Files  
Prevent drift between plan and apply.

### 41.7.5 Use Least Privilege Runners  
Avoid privileged containers.

---

## 41.8 State Security

### 41.8.1 Use Remote State  
Never use local state in production.

### 41.8.2 Enable State Versioning  
Supports rollback.

### 41.8.3 Enable State Locking  
Prevents concurrent modifications.

### 41.8.4 Restrict Access to State  
State may contain sensitive data.

### 41.8.5 Use Separate State per Environment  
Avoid cross-environment contamination.

---

## 41.9 Module Security

### 41.9.1 Validate Inputs  
Use validation blocks.

### 41.9.2 Avoid Hardcoded Values  
Use variables.

### 41.9.3 Avoid Exposing Sensitive Outputs  
Mark as sensitive.

### 41.9.4 Use Version Pinning  
Avoid unexpected changes.

### 41.9.5 Use Secure Defaults  
Examples:

- Private endpoints enabled  
- Encryption enabled  
- Logging enabled  

---

## 41.10 Drift Detection and Remediation

### 41.10.1 Nightly Drift Detection  
Use:

```bash
terraform plan -detailed-exitcode
```

### 41.10.2 Alert on Drift  
Notify:

- Teams  
- Slack  
- Email  

### 41.10.3 Remediate Drift  
Fix manually or via Terraform.

---

## 41.11 Logging and Monitoring

### 41.11.1 Enable Diagnostic Settings  
For all resources.

### 41.11.2 Enable Activity Logs  
Track changes.

### 41.11.3 Enable Alerts  
For:

- Unauthorized access  
- Policy violations  
- Drift  
- Failed deployments  

### 41.11.4 Use SIEM Integration  
Forward logs to:

- Sentinel  
- Splunk  
- Datadog  
- Elastic  

---

## 41.12 Anti‑Patterns

### 41.12.1 Storing Secrets in Code  
Never acceptable.

### 41.12.2 Using Admin Roles  
Too much privilege.

### 41.12.3 Public Endpoints by Default  
High risk.

### 41.12.4 No Policy Enforcement  
Leads to drift and inconsistency.

### 41.12.5 No State Protection  
Risk of corruption or exposure.

---

## 41.13 Best Practices Summary

### Identity  
- Use OIDC  
- Use least privilege  
- Use managed identities  

### Secrets  
- Use secret managers  
- Avoid storing secrets in state  

### Encryption  
- Encrypt everything  
- Use CMK/KMS/CMEK  

### Networking  
- Use private endpoints  
- Use segmentation  
- Use firewalls  

### Governance  
- Use policy as code  
- Enforce naming and tagging  

### Pipelines  
- Use approval gates  
- Use security scanning  

### State  
- Use remote state  
- Use versioning  
- Restrict access  

---

## 41.14 Summary

Security is foundational to Terraform operations.  
Key takeaways:

- Identity must follow least privilege and zero-trust principles  
- Secrets must be stored in secure secret managers  
- Encryption must be enforced across all resources  
- Network security must prioritize private access and segmentation  
- Governance must be automated through policy as code  
- CI/CD pipelines must enforce validation and approvals  
- State must be protected, versioned, and access-controlled  

In the next chapter, we will explore **Terraform Cost Optimization**, including resource sizing, tagging, monitoring, and automated cost controls.
