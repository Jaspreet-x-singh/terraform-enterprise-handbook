# Chapter 21  
## Multi‑Environment Deployment Workflows

Managing multiple environments — such as dev, test, stage, and prod — is one of the most important responsibilities in Terraform-driven infrastructure. A well‑designed multi‑environment workflow ensures consistency, safety, and scalability across your entire platform.

This chapter explores the most effective patterns for multi‑environment deployments, including directory structures, promotion workflows, GitOps models, and environment lifecycle management.

---

## 21.1 Why Multi‑Environment Workflows Matter

Multi‑environment workflows provide:

- **Isolation** — changes in dev don’t affect prod  
- **Safety** — promotion gates prevent accidental deployments  
- **Consistency** — environments follow the same structure  
- **Scalability** — supports multiple teams and modules  
- **Governance** — approvals and policies enforce compliance  

Without a structured workflow, environments drift apart, deployments become unpredictable, and production outages become more likely.

---

## 21.2 Environment Isolation Strategies

There are three primary strategies:

### 21.2.1 Strategy 1 — Directory‑Based Environments (Recommended)

```
environments/
  dev/
  test/
  prod/
```

Each environment has:

- Its own root module  
- Its own backend  
- Its own tfvars  
- Its own pipeline  

### 21.2.2 Strategy 2 — Workspace‑Based Environments (Not Recommended for Prod)

Workspaces provide lightweight isolation but lack:

- Provider isolation  
- Pipeline isolation  
- Backend isolation  

### 21.2.3 Strategy 3 — Repository‑Per‑Environment

Used in highly regulated environments.

Example:

```
repo-infra-dev
repo-infra-test
repo-infra-prod
```

---

## 21.3 Environment Promotion Models

Promotion models define how changes flow from one environment to another.

### 21.3.1 Model 1 — Git Branch Promotion (GitOps)

```
feature → dev → test → prod
```

Each branch corresponds to an environment.

### 21.3.2 Model 2 — Directory Promotion

```
environments/dev → environments/test → environments/prod
```

Changes are copied or merged between directories.

### 21.3.3 Model 3 — Tag‑Based Promotion

```
v1.0.0-dev → v1.0.0-test → v1.0.0-prod
```

Used for module versioning and releases.

---

## 21.4 GitOps for Terraform

GitOps applies Git workflows to infrastructure.

### 21.4.1 Core Principles

- Git is the source of truth  
- Pull requests trigger plans  
- Merges trigger applies  
- Environments are immutable  
- Promotion happens via Git  

### 21.4.2 Benefits

- Full audit history  
- Easy rollbacks  
- Strong governance  
- Predictable deployments  

---

## 21.5 Environment Lifecycle

A typical lifecycle:

1. **Development**  
2. **Testing**  
3. **Staging**  
4. **Production**  
5. **Decommissioning**  

Terraform supports each phase with:

- Separate state  
- Separate pipelines  
- Separate variables  
- Separate access controls  

---

## 21.6 Environment‑Specific Variables

Each environment has its own `terraform.tfvars`:

### dev.tfvars

```hcl
location = "eastus"
sku      = "Standard"
```

### prod.tfvars

```hcl
location = "eastus2"
sku      = "Premium"
```

This allows:

- Different regions  
- Different SKUs  
- Different scaling  
- Different naming conventions  

---

## 21.7 Environment‑Specific Backends

Each environment must have its own backend.

Example:

```
tfstate-dev
tfstate-test
tfstate-prod
```

This prevents:

- Cross‑environment corruption  
- Accidental production changes  
- State coupling  

---

## 21.8 Environment‑Specific Pipelines

Each environment should have its own CI/CD pipeline.

Example:

```
deploy-dev.yml
deploy-test.yml
deploy-prod.yml
```

Production pipelines include:

- Approval gates  
- Policy checks  
- Security scanning  
- Manual promotion  

---

## 21.9 Multi‑Module Environment Architecture

A scalable enterprise architecture:

```
live/
  dev/
    network/
    compute/
    monitoring/
  test/
    network/
    compute/
    monitoring/
  prod/
    network/
    compute/
    monitoring/

modules/
  network/
  compute/
  monitoring/
```

Each root module:

- Has its own state  
- Has its own pipeline  
- Uses shared child modules  

---

## 21.10 Promotion Workflows

### 21.10.1 Workflow 1 — Manual Promotion

1. Deploy to dev  
2. Validate  
3. Promote to test  
4. Validate  
5. Promote to prod  

### 21.10.2 Workflow 2 — Automated Promotion

Automated rules:

- All tests pass  
- All policies pass  
- No drift detected  
- Approval granted  

### 21.10.3 Workflow 3 — GitOps Promotion

Promotion happens via:

- Pull requests  
- Branch merges  
- Tag releases  

---

## 21.11 Drift Detection in Multi‑Environment Workflows

Nightly drift detection:

```bash
terraform plan -detailed-exitcode
```

Alerts sent to:

- Teams  
- Slack  
- Email  

Drift must be resolved before promotion.

---

## 21.12 Environment Governance

Governance includes:

- RBAC  
- Policy as Code  
- Approval gates  
- Secret management  
- Audit logs  

Production environments require:

- Restricted access  
- Mandatory approvals  
- Strict policies  

---

## 21.13 Environment Decommissioning

Terraform supports safe teardown:

1. Disable pipelines  
2. Backup state  
3. Run `terraform destroy`  
4. Archive state  
5. Remove backend container  
6. Remove service principals  

Decommissioning must be controlled and auditable.

---

## 21.14 Best Practices for Multi‑Environment Workflows

### 21.14.1 Use Directory‑Based Environments  
Provides true isolation.

### 21.14.2 Use Separate Backends  
Prevents cross‑environment corruption.

### 21.14.3 Use Separate Pipelines  
Avoids accidental production deployments.

### 21.14.4 Use GitOps Promotion  
Provides auditability and governance.

### 21.14.5 Use Environment‑Specific Variables  
Avoids hardcoding.

### 21.14.6 Use Policy as Code  
Enforces compliance.

### 21.14.7 Use Drift Detection  
Prevents surprises during promotion.

---

## 21.15 Summary

Multi‑environment workflows are essential for safe, scalable, and enterprise‑ready Terraform deployments.  
Key takeaways:

- Use directory‑based environments for isolation  
- Use separate backends and pipelines  
- Use GitOps for promotion  
- Use environment‑specific variables and tfvars  
- Use drift detection and policy as code  
- Use layered architectures for large organizations  

In the next chapter, we will explore **Terraform for Teams**, including collaboration models, code ownership, branching strategies, and organizational patterns.
