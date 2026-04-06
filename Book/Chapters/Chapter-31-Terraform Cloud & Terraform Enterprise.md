# Chapter 31  
## Terraform Cloud & Terraform Enterprise

Terraform Cloud (TFC) and Terraform Enterprise (TFE) provide a managed, scalable, and secure platform for running Terraform at organizational scale. They extend Terraform beyond local execution and CI/CD pipelines by offering remote execution, policy enforcement, state management, collaboration features, and enterprise governance.

This chapter explores the architecture, workflows, features, and best practices for using Terraform Cloud and Terraform Enterprise in production environments.

---

## 31.1 Terraform Cloud vs Terraform Enterprise

### 31.1.1 Terraform Cloud (TFC)
A SaaS offering hosted by HashiCorp.

Benefits:
- No infrastructure to manage  
- Automatic upgrades  
- Easy onboarding  
- Free tier available  

### 31.1.2 Terraform Enterprise (TFE)
A self‑hosted version for organizations requiring:

- Full data control  
- Private networking  
- Custom integrations  
- Air‑gapped deployments  

TFE is deployed on:
- Virtual machines  
- Kubernetes  
- HashiCorp’s reference architecture  

---

## 31.2 Core Features of TFC/TFE

### 31.2.1 Remote State Management
- Encrypted at rest  
- Versioned  
- Locked during operations  
- Accessible via CLI and API  

### 31.2.2 Remote Execution
Terraform runs on TFC/TFE infrastructure, not local machines.

Benefits:
- Consistent execution environment  
- No local secrets  
- No local provider installation  
- Scalable compute  

### 31.2.3 Workspaces
Workspaces isolate:
- State  
- Variables  
- Execution runs  
- Policies  

Workspaces map to:
- Environments  
- Modules  
- Applications  

### 31.2.4 VCS Integration
Supports:
- GitHub  
- GitLab  
- Bitbucket  
- Azure DevOps  

Triggers:
- Plan on pull request  
- Apply on merge  
- Policy checks  

### 31.2.5 Policy as Code (Sentinel)
Enterprise‑grade governance:
- Enforce naming  
- Enforce tagging  
- Restrict SKUs  
- Restrict regions  
- Require encryption  

### 31.2.6 Private Registry
A central module registry for your organization.

Benefits:
- Versioning  
- Documentation  
- Discoverability  
- Governance  

### 31.2.7 Run Tasks
Integrate external tools:
- Security scanners  
- Cost estimators  
- Compliance tools  

---

## 31.3 Workspaces in Depth

Workspaces are the heart of TFC/TFE.

### 31.3.1 Workspace Types

#### 1. VCS‑Driven Workspaces  
Triggered by:
- Pull requests  
- Merges  
- Tags  

#### 2. CLI‑Driven Workspaces  
Triggered by:
```bash
terraform login
terraform init
terraform apply
```

#### 3. API‑Driven Workspaces  
Used for automation and pipelines.

---

## 31.4 Workspace Design Patterns

### 31.4.1 Pattern 1 — One Workspace per Environment (Recommended)

```
network-dev
network-test
network-prod
```

### 31.4.2 Pattern 2 — One Workspace per Module

```
vnet
subnets
nsg
```

### 31.4.3 Pattern 3 — One Workspace per Application

```
app1-dev
app1-prod
```

### 31.4.4 Pattern 4 — One Workspace per Region

```
network-eastus
network-westus
```

---

## 31.5 Variables and Secrets

### 31.5.1 Variable Types
- Terraform variables  
- Environment variables  
- Sensitive variables  

### 31.5.2 Sensitive Variables
Encrypted and hidden in UI.

Examples:
- Client secrets  
- API keys  
- Database passwords  

### 31.5.3 Variable Sets
Reusable variable groups.

Examples:
- Global tags  
- Global naming conventions  
- Global identity configuration  

---

## 31.6 Remote Execution Workflow

A typical run includes:

1. **Plan**  
2. **Policy Check**  
3. **Cost Estimation**  
4. **Manual Approval (optional)**  
5. **Apply**  
6. **Post‑Run Tasks**  

Runs are logged and auditable.

---

## 31.7 Policy as Code with Sentinel

Sentinel policies enforce governance.

### 31.7.1 Example: Require Tags

```hcl
import "tfplan/v2" as tfplan

required_tags = ["owner", "environment"]

deny if any tfplan.resource_changes as rc {
  missing = required_tags - keys(rc.change.after.tags)
  length(missing) > 0
}
```

### 31.7.2 Policy Types

- **Advisory** — warn  
- **Soft Mandatory** — block unless overridden  
- **Hard Mandatory** — block always  

---

## 31.8 Cost Estimation

TFC/TFE integrates with cost estimation tools.

Benefits:
- Predict cost before apply  
- Enforce cost policies  
- Prevent expensive mistakes  

---

## 31.9 Private Module Registry

The private registry provides:

- Versioning  
- Documentation  
- Examples  
- Search  
- Governance  

Modules can be:
- Terraform modules  
- Providers  
- Policy sets  

---

## 31.10 Run Tasks

Run tasks integrate external tools into the Terraform workflow.

Examples:
- Checkov  
- TFLint  
- OPA  
- Cost estimation tools  
- Security scanners  

Run tasks can be:
- Pre‑plan  
- Post‑plan  
- Pre‑apply  
- Post‑apply  

---

## 31.11 Notifications and Integrations

TFC/TFE integrates with:

- Slack  
- Teams  
- Email  
- Webhooks  
- SIEM tools  

Notifications include:
- Run started  
- Plan finished  
- Policy failed  
- Apply succeeded  

---

## 31.12 Terraform Agents

Terraform Agents allow TFC/TFE to run Terraform inside your private network.

Use cases:
- Private endpoints  
- On‑prem resources  
- Restricted networks  
- Air‑gapped environments  

Agents run:
- Terraform  
- Providers  
- External tools  

---

## 31.13 Terraform Enterprise Architecture

TFE supports:

- Active/active clustering  
- External PostgreSQL  
- External object storage  
- Private networking  
- Air‑gapped deployments  

TFE components:
- Application layer  
- Worker layer  
- Data layer  
- Proxy layer  

---

## 31.14 Migration to Terraform Cloud/Enterprise

### 31.14.1 Migration Steps

1. Export local state  
2. Create workspace  
3. Upload state  
4. Configure variables  
5. Configure VCS  
6. Run plan  
7. Validate  
8. Apply  

### 31.14.2 Migration Considerations

- State locking  
- Provider versions  
- Variable sets  
- Policy sets  
- Module registry  

---

## 31.15 TFC/TFE Anti‑Patterns

### 31.15.1 Using One Workspace for All Environments  
Leads to chaos.

### 31.15.2 Storing Secrets in Code  
Use sensitive variables.

### 31.15.3 No Policy Enforcement  
Risky for production.

### 31.15.4 No Variable Sets  
Leads to duplication.

### 31.15.5 No Workspace Naming Standards  
Hard to manage at scale.

---

## 31.16 Best Practices Summary

### Workspaces  
- Use one workspace per environment  
- Use variable sets  
- Use naming conventions  

### Governance  
- Use Sentinel  
- Use cost estimation  
- Use run tasks  

### Security  
- Use sensitive variables  
- Use Terraform Agents for private networks  

### Collaboration  
- Use VCS integration  
- Use private registry  
- Use notifications  

---

## 31.17 Summary

Terraform Cloud and Terraform Enterprise provide a powerful platform for scaling Terraform across teams and organizations.  
Key takeaways:

- Workspaces isolate state and execution  
- Remote execution ensures consistency  
- Sentinel enforces governance  
- Variable sets reduce duplication  
- Private registry centralizes modules  
- Run tasks integrate security and compliance  
- Terraform Agents support private networks  
- TFE provides enterprise‑grade control and security  

In the next chapter, we will explore **Terraform Automation & API Integrations**, including the Terraform Cloud API, automation pipelines, and custom tooling.
