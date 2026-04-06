# Chapter 39  
## Architecture Patterns

Terraform is not just a tool for provisioning resources — it is a framework for expressing infrastructure architecture. As organizations scale, consistent architecture patterns become essential for reliability, security, governance, and maintainability. Terraform enables these patterns to be codified, versioned, and enforced across teams and environments.

This chapter explores the most important architecture patterns used in enterprise cloud environments, including hub‑and‑spoke, landing zones, multi‑region deployments, microservices infrastructure, shared services, and zero‑trust networking.

---

## 39.1 Why Architecture Patterns Matter

Architecture patterns provide:

- **Consistency** across teams  
- **Predictability** across environments  
- **Security** through standardization  
- **Scalability** through modularity  
- **Governance** through enforced structure  
- **Reusability** through shared modules  
- **Operational clarity** through well-defined boundaries  

Terraform allows these patterns to be implemented as reusable modules and root module compositions.

---

## 39.2 Pattern 1 — Hub‑and‑Spoke Architecture

Hub‑and‑spoke is the most common enterprise network pattern.

### 39.2.1 Hub Responsibilities

- Shared networking  
- Firewalls  
- DNS  
- Bastion hosts  
- Logging  
- Identity services  

### 39.2.2 Spoke Responsibilities

- Application workloads  
- Databases  
- Storage  
- Compute  
- AKS/EKS/GKE clusters  

### 39.2.3 Terraform Implementation

Use modules:

```
modules/
  hub/
  spoke/
  firewall/
  dns/
```

Root modules:

```
environments/
  prod/
    hub/
    spoke-app1/
    spoke-app2/
```

### 39.2.4 Benefits

- Strong isolation  
- Centralized governance  
- Scalable network topology  

---

## 39.3 Pattern 2 — Landing Zone Architecture

Landing zones provide a standardized foundation for cloud environments.

### 39.3.1 Components

- Identity  
- Networking  
- Logging  
- Security  
- Monitoring  
- Policies  
- Resource hierarchy  

### 39.3.2 Terraform Implementation

Modules:

```
modules/
  identity/
  network/
  security/
  monitoring/
  policy/
```

Landing zone root module:

```
landing-zone/
  main.tf
  variables.tf
  outputs.tf
```

### 39.3.3 Benefits

- Enterprise-ready foundation  
- Enforced governance  
- Repeatable environment creation  

---

## 39.4 Pattern 3 — Multi‑Region Architecture

Multi‑region architectures support:

- High availability  
- Disaster recovery  
- Low latency  
- Regulatory requirements  

### 39.4.1 Terraform Implementation

Use provider aliases:

```hcl
provider "azurerm" {
  alias    = "east"
  features = {}
}

provider "azurerm" {
  alias    = "west"
  features = {}
}
```

Modules deployed twice:

```
module "network_east" {
  providers = { azurerm = azurerm.east }
}

module "network_west" {
  providers = { azurerm = azurerm.west }
}
```

### 39.4.2 Benefits

- Regional redundancy  
- Failover capability  
- Performance optimization  

---

## 39.5 Pattern 4 — Shared Services Architecture

Shared services provide centralized capabilities:

- Logging  
- Monitoring  
- DNS  
- Identity  
- Key management  
- Container registries  

### 39.5.1 Terraform Implementation

Modules:

```
modules/
  log-analytics/
  key-vault/
  acr/
  dns/
```

Shared services root module:

```
shared-services/
  main.tf
```

### 39.5.2 Benefits

- Reduced duplication  
- Centralized governance  
- Cost efficiency  

---

## 39.6 Pattern 5 — Microservices Infrastructure

Microservices require:

- Independent deployments  
- Isolated networks  
- Independent scaling  
- Independent pipelines  

### 39.6.1 Terraform Implementation

Each microservice has:

- Its own root module  
- Its own state  
- Its own pipeline  

Example:

```
services/
  orders/
  payments/
  users/
```

### 39.6.2 Benefits

- High agility  
- Independent scaling  
- Fault isolation  

---

## 39.7 Pattern 6 — Zero‑Trust Architecture

Zero‑trust requires:

- No implicit trust  
- Identity-based access  
- Micro-segmentation  
- Private endpoints  
- Strict firewall rules  

### 39.7.1 Terraform Implementation

Enforce:

- Private endpoints  
- NSGs/firewalls  
- Managed identities  
- Conditional access  
- Diagnostic settings  

Modules:

```
modules/
  private-endpoints/
  firewall/
  identity/
```

### 39.7.2 Benefits

- Strong security posture  
- Reduced attack surface  
- Compliance alignment  

---

## 39.8 Pattern 7 — GitOps Architecture

GitOps applies Git workflows to infrastructure.

### 39.8.1 Principles

- Git is the source of truth  
- Pull requests drive changes  
- Pipelines enforce validation  
- Environments are promoted via Git  

### 39.8.2 Terraform Implementation

Branches:

```
main → prod
develop → test
feature/* → dev
```

Pipelines:

- Plan on PR  
- Apply on merge  
- Approval gates  

### 39.8.3 Benefits

- Strong auditability  
- Predictable deployments  
- Clear promotion workflow  

---

## 39.9 Pattern 8 — Event‑Driven Infrastructure

Infrastructure reacts to events:

- New application version  
- New environment request  
- Scheduled rebuild  
- Drift detection  

### 39.9.1 Terraform Implementation

Use:

- Terraform Cloud API  
- Webhooks  
- GitHub Actions  
- Azure Functions / AWS Lambda  

### 39.9.2 Benefits

- Automation  
- Reduced manual effort  
- Faster deployments  

---

## 39.10 Pattern 9 — Multi‑Cloud Architecture

Multi‑cloud requires:

- Cloud-specific modules  
- Provider aliases  
- Cross-cloud networking  
- Cross-cloud identity  

### 39.10.1 Terraform Implementation

Providers:

```hcl
provider "azurerm" {}
provider "aws" {}
provider "google" {}
```

Modules:

```
modules/
  azure-network/
  aws-network/
  gcp-network/
```

### 39.10.2 Benefits

- Avoid vendor lock-in  
- Use best-of-breed services  
- Global resilience  

---

## 39.11 Pattern 10 — Modular Monolith Architecture

A modular monolith uses:

- One repo  
- Many modules  
- Many root modules  
- Shared pipelines  

### 39.11.1 Terraform Implementation

```
infrastructure/
  modules/
  environments/
  pipelines/
```

### 39.11.2 Benefits

- Easy governance  
- Easy onboarding  
- Strong consistency  

---

## 39.12 Anti‑Patterns

### 39.12.1 Flat Architecture  
No structure → chaos.

### 39.12.2 One Giant Root Module  
Slow, fragile, unscalable.

### 39.12.3 No Shared Services  
Duplication and inconsistency.

### 39.12.4 No Landing Zone  
Weak governance.

### 39.12.5 Overly Complex Modules  
Hard to maintain.

---

## 39.13 Best Practices Summary

### Use  
- Hub‑and‑spoke for networking  
- Landing zones for governance  
- Multi‑region for resilience  
- Shared services for efficiency  
- Microservices for agility  
- Zero‑trust for security  
- GitOps for predictability  
- Event-driven workflows for automation  
- Multi-cloud for flexibility  

### Avoid  
- Monolithic state  
- Unstructured environments  
- Manual deployments  
- Inconsistent patterns  

---

## 39.14 Summary

Architecture patterns are the backbone of scalable, secure, and maintainable cloud environments.  
Key takeaways:

- Terraform enables architecture patterns to be codified and enforced  
- Hub‑and‑spoke and landing zones are foundational for enterprise networks  
- Multi‑region and multi‑cloud patterns support resilience and flexibility  
- Shared services and microservices patterns support modularity  
- Zero‑trust and GitOps patterns support security and governance  
- Avoid anti-patterns like monolithic modules or unstructured environments  

In the next chapter, we will explore **Terraform Infrastructure Blueprints**, including reusable architecture templates for common workloads.
