# Chapter 20  
## Terraform CI/CD Pipelines

Infrastructure-as-code becomes truly powerful when paired with automation. CI/CD pipelines ensure that Terraform code is validated, tested, planned, and applied consistently across environments. They eliminate manual steps, reduce human error, and enforce governance and compliance.

This chapter explores how to design, build, and operate production-grade CI/CD pipelines for Terraform using GitHub Actions, Azure DevOps, GitLab CI, and enterprise patterns.

---

## 20.1 Why CI/CD for Terraform?

CI/CD pipelines provide:

- **Consistency** — every deployment follows the same steps  
- **Safety** — automated validation prevents mistakes  
- **Governance** — approvals and policies enforce compliance  
- **Speed** — faster deployments with fewer manual steps  
- **Auditability** — logs and history for every change  
- **Scalability** — supports multi-team, multi-environment workflows  

Without CI/CD, Terraform becomes error-prone and difficult to scale.

---

## 20.2 Core Stages of a Terraform Pipeline

A production-grade pipeline typically includes:

1. **Linting**  
2. **Formatting**  
3. **Validation**  
4. **Security scanning**  
5. **Plan**  
6. **Manual approval (for prod)**  
7. **Apply**  
8. **Post-deployment checks**  

Each stage catches different classes of issues.

---

## 20.3 Stage 1 — Formatting

```bash
terraform fmt -check -recursive
```

Ensures consistent formatting across teams.

---

## 20.4 Stage 2 — Validation

```bash
terraform validate
```

Checks:

- Syntax  
- Types  
- Provider configuration  
- Module structure  

---

## 20.5 Stage 3 — Linting

### 20.5.1 TFLint

```bash
tflint
```

Detects:

- Invalid arguments  
- Deprecated fields  
- Provider-specific issues  

### 20.5.2 Checkov

```bash
checkov -d .
```

Detects:

- Security misconfigurations  
- Compliance violations  

---

## 20.6 Stage 4 — Terraform Init

```bash
terraform init -input=false
```

Initializes:

- Providers  
- Modules  
- Backend  

---

## 20.7 Stage 5 — Terraform Plan

```bash
terraform plan -input=false -out=tfplan
```

Generates an execution plan.

### 20.7.1 Why Save the Plan?

- Ensures apply uses the exact plan  
- Prevents drift between plan and apply  
- Enables plan review  

---

## 20.8 Stage 6 — Manual Approval

Required for:

- Production  
- Sensitive environments  
- High-risk changes  

Approval gates prevent accidental deployments.

---

## 20.9 Stage 7 — Terraform Apply

```bash
terraform apply -input=false tfplan
```

Executes the plan exactly as reviewed.

---

## 20.10 Stage 8 — Post-Deployment Validation

Examples:

- Smoke tests  
- Connectivity checks  
- Monitoring validation  
- Policy checks  

Ensures infrastructure is healthy after deployment.

---

## 20.11 GitHub Actions for Terraform

A typical GitHub Actions workflow:

### 20.11.1 `terraform-plan.yml`

```yaml
name: Terraform Plan

on:
  pull_request:
    branches: [ main ]

jobs:
  plan:
    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout@v4

    - name: Setup Terraform
      uses: hashicorp/setup-terraform@v3

    - name: Terraform Init
      run: terraform init

    - name: Terraform Plan
      run: terraform plan -no-color
```

### 20.11.2 `terraform-apply.yml`

```yaml
name: Terraform Apply

on:
  workflow_dispatch:

jobs:
  apply:
    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout@v4

    - name: Setup Terraform
      uses: hashicorp/setup-terraform@v3

    - name: Terraform Init
      run: terraform init

    - name: Terraform Apply
      run: terraform apply -auto-approve
```

---

## 20.12 Azure DevOps Pipelines for Terraform

### 20.12.1 Plan Stage

```yaml
- task: TerraformCLI@1
  inputs:
    command: 'plan'
    workingDirectory: '$(System.DefaultWorkingDirectory)'
    environmentServiceName: 'AzureServiceConnection'
```

### 20.12.2 Apply Stage

```yaml
- task: TerraformCLI@1
  inputs:
    command: 'apply'
    environmentServiceName: 'AzureServiceConnection'
```

Azure DevOps supports:

- Variable groups  
- Key Vault integration  
- Approval gates  
- Multi-stage pipelines  

---

## 20.13 GitLab CI for Terraform

Example:

```yaml
stages:
  - validate
  - plan
  - apply

validate:
  stage: validate
  script:
    - terraform fmt -check
    - terraform validate

plan:
  stage: plan
  script:
    - terraform plan -out=tfplan
  artifacts:
    paths:
      - tfplan

apply:
  stage: apply
  when: manual
  script:
    - terraform apply tfplan
```

---

## 20.14 OIDC Authentication (Best Practice)

OIDC eliminates long-lived credentials.

### 20.14.1 GitHub → Azure

```yaml
permissions:
  id-token: write
  contents: read
```

Azure federated identity:

- No client secrets  
- No key rotation  
- No secret leaks  

---

## 20.15 Environment-Specific Pipelines

Each environment should have:

- Its own backend  
- Its own variables  
- Its own pipeline  

Example:

```
deploy-dev.yml
deploy-test.yml
deploy-prod.yml
```

This prevents accidental production deployments.

---

## 20.16 Multi-Module CI/CD Architecture

Each root module should have:

- Its own pipeline  
- Its own state  
- Its own tfvars  
- Its own approvals  

Example:

```
network/
compute/
monitoring/
security/
```

Each with its own workflow.

---

## 20.17 Drift Detection Pipelines

Nightly drift detection:

```bash
terraform plan -detailed-exitcode
```

Exit codes:

- `0` — no changes  
- `1` — error  
- `2` — drift detected  

Drift alerts can be sent to:

- Teams  
- Slack  
- Email  

---

## 20.18 Policy as Code

Use:

- **OPA** (Open Policy Agent)  
- **Sentinel** (Terraform Cloud)  
- **Azure Policy**  
- **AWS Config**  

Policies enforce:

- Tagging  
- Naming  
- Security  
- Compliance  

---

## 20.19 Best Practices for Terraform CI/CD

### 20.19.1 Never Use Auto-Approve in Production  
Always require approval.

### 20.19.2 Use OIDC Instead of Secrets  
Eliminates credential leaks.

### 20.19.3 Use Separate Pipelines per Environment  
Prevents accidental prod changes.

### 20.19.4 Use Plan Files  
Ensures apply uses reviewed plan.

### 20.19.5 Use Linting and Security Scans  
Catch issues early.

### 20.19.6 Use State Locking  
Avoid corruption.

### 20.19.7 Use tfvars per Environment  
Avoid hardcoding values.

---

## 20.20 Summary

CI/CD pipelines are essential for safe, scalable, and enterprise-ready Terraform deployments.  
Key takeaways:

- Pipelines enforce consistency and governance  
- Use linting, validation, and security scanning  
- Use plan → approval → apply workflows  
- Use OIDC for secure authentication  
- Use environment-specific pipelines  
- Use drift detection and policy as code  
- Use multi-module pipelines for large architectures  

In the next chapter, we will explore **Terraform Workflows for Multi-Environment Deployments**, including promotion pipelines, GitOps patterns, and environment lifecycle management.
