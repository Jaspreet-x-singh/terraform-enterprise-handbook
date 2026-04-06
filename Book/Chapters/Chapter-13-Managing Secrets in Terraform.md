# Chapter 13  
## Managing Secrets in Terraform

Secrets are an unavoidable part of infrastructure: API keys, client secrets, passwords, connection strings, certificates, SSH keys, and more. Managing these securely is one of the most important responsibilities of any Terraform practitioner.

Terraform is **not** a secret manager. It can *consume* secrets, but it should never *store* or *generate* long‑term secrets directly. This chapter explores how to handle secrets safely, how to integrate with cloud-native secret managers, and how to design secure CI/CD pipelines for Terraform.

---

## 13.1 Why Secret Management Matters

Poor secret management leads to:

- Credential leaks  
- Compromised cloud accounts  
- Lateral movement attacks  
- Regulatory violations  
- Production outages  

Terraform configurations, state files, and CI/CD logs can all become attack vectors if secrets are not handled properly.

---

## 13.2 Where Secrets Should *Not* Live

### 13.2.1 Never Store Secrets in Terraform Code

Bad:

```hcl
variable "client_secret" {
  default = "SuperSecret123"
}
```

### 13.2.2 Never Store Secrets in `terraform.tfvars`

Bad:

```hcl
client_secret = "SuperSecret123"
```

### 13.2.3 Never Store Secrets in State Files

Terraform state may contain:

- Passwords  
- Keys  
- Connection strings  
- Certificates  

State must be encrypted and access‑controlled.

---

## 13.3 Terraform State and Secrets

Terraform state is a JSON document that stores:

- Resource IDs  
- Attributes  
- Metadata  
- Sensitive values (unless redacted)  

### 13.3.1 Sensitive Values in State

Even if a variable is marked `sensitive = true`, Terraform will still store it in state.

Example:

```hcl
variable "password" {
  type      = string
  sensitive = true
}
```

This hides the value in logs, but **not** in state.

### 13.3.2 Protecting State

State must be:

- Encrypted at rest  
- Access‑controlled  
- Stored in a secure backend  
- Locked during operations  

Recommended backends:

- Azure Storage (with encryption + RBAC)  
- AWS S3 (with KMS + IAM)  
- GCP Storage (with CMEK)  
- Terraform Cloud (built‑in security)  

---

## 13.4 Cloud-Native Secret Managers

Terraform integrates with all major cloud secret managers.

---

## 13.5 Azure Key Vault

Azure Key Vault is the recommended way to store secrets in Azure.

### 13.5.1 Reading Secrets from Key Vault

```hcl
data "azurerm_key_vault_secret" "client_secret" {
  name         = "client-secret"
  key_vault_id = azurerm_key_vault.kv.id
}
```

Use the secret:

```hcl
client_secret = data.azurerm_key_vault_secret.client_secret.value
```

### 13.5.2 Storing Secrets in Key Vault

Terraform can create secrets:

```hcl
resource "azurerm_key_vault_secret" "example" {
  name         = "db-password"
  value        = var.db_password
  key_vault_id = azurerm_key_vault.kv.id
}
```

But avoid generating long‑term secrets in Terraform.

---

## 13.6 AWS Secrets Manager

Example:

```hcl
data "aws_secretsmanager_secret_version" "db" {
  secret_id = "db-password"
}
```

Use the secret:

```hcl
db_password = data.aws_secretsmanager_secret_version.db.secret_string
```

---

## 13.7 GCP Secret Manager

Example:

```hcl
data "google_secret_manager_secret_version" "db" {
  secret  = "db-password"
  version = "latest"
}
```

Use the secret:

```hcl
db_password = data.google_secret_manager_secret_version.db.secret_data
```

---

## 13.8 GitHub Actions and Secrets

GitHub Actions supports secure secret storage.

### 13.8.1 Accessing Secrets in Terraform Workflows

```yaml
env:
  ARM_CLIENT_SECRET: ${{ secrets.ARM_CLIENT_SECRET }}
```

Pass to Terraform:

```bash
export ARM_CLIENT_SECRET="${ARM_CLIENT_SECRET}"
```

### 13.8.2 OIDC Authentication (Recommended)

OIDC eliminates long‑lived secrets.

Example:

```yaml
permissions:
  id-token: write
  contents: read
```

Terraform authenticates using a federated identity.

---

## 13.9 Azure DevOps and Secrets

Azure DevOps supports:

- Variable groups  
- Key Vault integration  
- Secret masking  

Example:

```yaml
variables:
- group: prod-secrets
```

---

## 13.10 Generating Secrets Securely

Terraform can generate secrets using:

```hcl
resource "random_password" "password" {
  length  = 32
  special = true
}
```

But:

- The generated value will be stored in state  
- It must be rotated manually  
- It should be pushed into a secret manager  

Best practice:

1. Generate secret  
2. Store in Key Vault / Secrets Manager  
3. Use secret from manager  
4. Never expose secret in outputs  

---

## 13.11 Avoiding Secret Leaks in Logs

### 13.11.1 Mark Outputs as Sensitive

```hcl
output "password" {
  value     = random_password.password.result
  sensitive = true
}
```

### 13.11.2 Avoid Echoing Secrets in Scripts

Bad:

```bash
echo $PASSWORD
```

---

## 13.12 Secret Rotation

Secrets should be rotated:

- Automatically  
- Regularly  
- Without downtime  

Terraform is not a rotation tool.  
Use:

- Azure Key Vault rotation policies  
- AWS Secrets Manager rotation lambdas  
- GCP Secret Manager rotation schedules  

---

## 13.13 Best Practices for Secret Management

### 13.13.1 Never Store Secrets in Code  
Use secret managers.

### 13.13.2 Never Store Secrets in State  
Use data sources instead of variables.

### 13.13.3 Use OIDC Instead of Service Principals  
Eliminates long‑lived credentials.

### 13.13.4 Use Cloud-Native Secret Managers  
Key Vault, Secrets Manager, Secret Manager.

### 13.13.5 Use CI/CD Secret Stores  
GitHub Secrets, Azure DevOps Variable Groups.

### 13.13.6 Limit Access to State  
Use RBAC and encryption.

### 13.13.7 Avoid Outputting Secrets  
Mark outputs as sensitive.

---

## 13.14 Summary

Managing secrets securely is essential for safe Terraform usage.  
Key takeaways:

- Terraform is not a secret manager  
- State files can leak secrets  
- Use cloud-native secret managers  
- Use OIDC to eliminate long-lived credentials  
- Use CI/CD secret stores  
- Never store secrets in code or tfvars  
- Always protect state with encryption and RBAC  

In the next chapter, we will explore **Terraform State in depth**, including remote backends, locking, drift detection, and state recovery.
