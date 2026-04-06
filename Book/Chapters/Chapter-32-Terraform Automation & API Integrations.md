# Chapter 32  
## Terraform Automation & API Integrations

Terraform is powerful on its own, but its true potential emerges when it becomes part of a larger automation ecosystem. Terraform Cloud, Terraform Enterprise, and the Terraform CLI all expose APIs that allow you to integrate Terraform with custom tooling, orchestration systems, ticketing systems, chatbots, and enterprise automation platforms.

This chapter explores how to automate Terraform using APIs, webhooks, custom scripts, event-driven workflows, and integrations with external systems.

---

## 32.1 Why Automate Terraform?

Automation enables:

- Faster deployments  
- Reduced manual effort  
- Consistent workflows  
- Integration with ITSM systems  
- Event-driven infrastructure  
- Self-service provisioning  
- Governance and auditability  

Automation transforms Terraform from a tool into a platform.

---

## 32.2 Terraform Cloud API Overview

Terraform Cloud exposes a REST API that supports:

- Workspace creation  
- Variable management  
- Run creation  
- State uploads  
- Policy management  
- Module registry operations  
- Team and user management  

API base URL:

```
https://app.terraform.io/api/v2
```

Authentication uses:

- User tokens  
- Team tokens  
- Service account tokens  

---

## 32.3 Creating a Run via API

### 32.3.1 Step 1 — Create a Configuration Version

```bash
curl \
  --header "Authorization: Bearer $TOKEN" \
  --header "Content-Type: application/vnd.api+json" \
  --request POST \
  --data '{
    "data": {
      "type": "configuration-versions"
    }
  }' \
  https://app.terraform.io/api/v2/workspaces/ws-123/configuration-versions
```

### 32.3.2 Step 2 — Upload Configuration Files

Upload a tarball of your Terraform code.

### 32.3.3 Step 3 — Create a Run

```bash
curl \
  --header "Authorization: Bearer $TOKEN" \
  --header "Content-Type: application/vnd.api+json" \
  --request POST \
  --data '{
    "data": {
      "attributes": {
        "is-destroy": false,
        "message": "Triggered via API"
      },
      "type": "runs",
      "relationships": {
        "workspace": {
          "data": { "type": "workspaces", "id": "ws-123" }
        }
      }
    }
  }' \
  https://app.terraform.io/api/v2/runs
```

---

## 32.4 Automating Variable Management

### 32.4.1 Create a Variable

```bash
curl \
  --header "Authorization: Bearer $TOKEN" \
  --header "Content-Type: application/vnd.api+json" \
  --request POST \
  --data '{
    "data": {
      "type": "vars",
      "attributes": {
        "key": "location",
        "value": "eastus",
        "category": "terraform"
      }
    }
  }' \
  https://app.terraform.io/api/v2/workspaces/ws-123/vars
```

### 32.4.2 Update a Variable  
Use PATCH with the variable ID.

---

## 32.5 Automating State Operations

### 32.5.1 Download State

```bash
curl \
  --header "Authorization: Bearer $TOKEN" \
  https://app.terraform.io/api/v2/workspaces/ws-123/current-state-version/download
```

### 32.5.2 Upload State  
Used for migrations or imports.

---

## 32.6 Webhooks and Event-Driven Automation

Terraform Cloud supports outbound webhooks for:

- Run created  
- Run completed  
- Policy check failed  
- Cost estimation completed  

Use cases:

- Trigger Slack notifications  
- Trigger ServiceNow tickets  
- Trigger downstream pipelines  
- Trigger monitoring updates  

---

## 32.7 Integrating Terraform with ITSM Systems

### 32.7.1 ServiceNow Integration

Automate:

- Change requests  
- Approvals  
- CMDB updates  

Workflow:

1. User submits ServiceNow request  
2. ServiceNow triggers Terraform run  
3. Terraform applies infrastructure  
4. Terraform updates CMDB via API  

### 32.7.2 Jira Integration

Automate:

- Issue creation  
- Deployment tracking  
- Audit logs  

---

## 32.8 Integrating Terraform with ChatOps

ChatOps enables teams to trigger Terraform actions from chat platforms.

### 32.8.1 Slack Integration

Examples:

- `/terraform plan dev`  
- `/terraform apply prod`  
- `/terraform status network`  

Slack bot triggers:

- API-driven runs  
- Workspace queries  
- State lookups  

### 32.8.2 Microsoft Teams Integration

Similar workflows using Teams bots.

---

## 32.9 Integrating Terraform with CI/CD Beyond GitHub Actions

### 32.9.1 Jenkins

Use:

- Terraform CLI  
- Terraform Cloud API  
- Jenkins credentials store  

### 32.9.2 Argo Workflows

Event-driven GitOps pipelines.

### 32.9.3 Tekton Pipelines

Kubernetes-native CI/CD.

---

## 32.10 Custom Provisioning Portals

Terraform can power self-service portals.

### 32.10.1 Architecture

1. User selects resource  
2. Portal calls Terraform Cloud API  
3. Terraform runs  
4. Portal displays outputs  

### 32.10.2 Use Cases

- Developer self-service  
- Sandbox environments  
- Temporary test environments  

---

## 32.11 Integrating Terraform with Configuration Management

Terraform provisions infrastructure; configuration tools manage software.

### 32.11.1 Ansible Integration

Terraform outputs → Ansible inventory.

### 32.11.2 Chef/Puppet Integration

Terraform creates nodes → CM tools configure them.

### 32.11.3 SaltStack Integration

Event-driven configuration.

---

## 32.12 Integrating Terraform with Monitoring Systems

### 32.12.1 Datadog

Terraform deploys:

- Monitors  
- Dashboards  
- Integrations  

### 32.12.2 Prometheus/Grafana

Terraform deploys:

- Dashboards  
- Alert rules  
- Exporters  

---

## 32.13 Integrating Terraform with Secrets Managers

### 32.13.1 Azure Key Vault  
Use data sources to fetch secrets.

### 32.13.2 AWS Secrets Manager  
Use IAM roles for access.

### 32.13.3 HashiCorp Vault  
Use Vault provider for dynamic secrets.

---

## 32.14 Building Custom Terraform Tools

Examples:

- Terraform wrapper scripts  
- Custom CLIs  
- Internal developer portals  
- Drift detection bots  
- Compliance scanners  

Languages commonly used:

- Python  
- Go  
- Node.js  

---

## 32.15 Automation Anti‑Patterns

### 32.15.1 Triggering Apply Automatically for Prod  
Always require approval.

### 32.15.2 Storing Tokens in Code  
Use secret managers.

### 32.15.3 Over-Automation  
Humans must still review plans.

### 32.15.4 No Audit Logging  
Dangerous in regulated environments.

---

## 32.16 Best Practices Summary

### Automation  
- Use API-driven workflows  
- Use webhooks for event-driven automation  
- Use ChatOps for collaboration  

### Security  
- Use OIDC  
- Use secret managers  
- Use least privilege  

### Governance  
- Integrate with ITSM  
- Use policy checks  
- Use audit logs  

### Scalability  
- Build self-service portals  
- Use variable sets  
- Use workspace standards  

---

## 32.17 Summary

Terraform automation unlocks the ability to integrate infrastructure provisioning into broader enterprise workflows.  
Key takeaways:

- Terraform Cloud API enables full automation  
- Webhooks support event-driven workflows  
- ITSM integrations enforce governance  
- ChatOps improves collaboration  
- Custom portals enable self-service  
- Monitoring, CM, and secrets tools integrate seamlessly  
- Avoid anti-patterns like auto-apply in production  

In the next chapter, we will explore **Terraform at Scale**, including organizational patterns, multi-team governance, module registries, and enterprise architecture.
