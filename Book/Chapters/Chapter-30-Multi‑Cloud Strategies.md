# Chapter 30  
## Multi‑Cloud Strategies

Multi‑cloud architectures are no longer niche — they are increasingly common in enterprises seeking resilience, vendor independence, regulatory compliance, or best‑of‑breed services across cloud providers. Terraform is uniquely positioned to enable multi‑cloud deployments because it provides a unified workflow, consistent language, and provider ecosystem that spans Azure, AWS, GCP, and beyond.

This chapter explores multi‑cloud motivations, patterns, provider strategies, state management, networking, identity, governance, and real‑world architectures.

---

## 30.1 Why Multi‑Cloud?

Organizations adopt multi‑cloud for several reasons:

### 30.1.1 Avoid Vendor Lock‑In  
Reduce dependency on a single provider.

### 30.1.2 Regulatory Requirements  
Some industries require workloads to run in multiple jurisdictions.

### 30.1.3 High Availability and Disaster Recovery  
Cross‑cloud failover strategies.

### 30.1.4 Best‑of‑Breed Services  
Use:

- Azure AD for identity  
- AWS for compute scale  
- GCP for analytics  

### 30.1.5 Mergers and Acquisitions  
Inherited cloud footprints.

---

## 30.2 Challenges of Multi‑Cloud

Multi‑cloud introduces complexity:

- Different IAM models  
- Different networking models  
- Different monitoring systems  
- Different security controls  
- Different cost models  
- Different APIs and limits  

Terraform helps unify these differences, but architecture must be deliberate.

---

## 30.3 Terraform’s Role in Multi‑Cloud

Terraform provides:

- A single language (HCL)  
- A single workflow (init → plan → apply)  
- A single state model  
- A provider ecosystem  
- A modular architecture  
- CI/CD integration  

Terraform becomes the “control plane” for multi‑cloud deployments.

---

## 30.4 Provider Strategy

Each cloud provider has its own Terraform provider:

- `azurerm` for Azure  
- `aws` for AWS  
- `google` for GCP  

### 30.4.1 Multiple Providers in One Root Module

```hcl
provider "azurerm" {
  features {}
}

provider "aws" {
  region = "us-east-1"
}

provider "google" {
  project = var.project_id
}
```

### 30.4.2 Provider Aliases

```hcl
provider "aws" {
  alias  = "west"
  region = "us-west-2"
}
```

### 30.4.3 Passing Providers to Modules

```hcl
module "network" {
  source  = "../network"
  providers = {
    aws = aws.west
  }
}
```

---

## 30.5 Multi‑Cloud Module Design

### 30.5.1 Pattern 1 — Cloud‑Specific Modules  
Separate modules per cloud:

```
modules/
  azure-network/
  aws-network/
  gcp-network/
```

### 30.5.2 Pattern 2 — Unified Interface Modules  
Expose a single interface:

```hcl
variable "cloud" {
  type = string
}

locals {
  is_azure = var.cloud == "azure"
  is_aws   = var.cloud == "aws"
}
```

Conditional resource creation:

```hcl
resource "azurerm_virtual_network" "vnet" {
  count = local.is_azure ? 1 : 0
}
```

### 30.5.3 Pattern 3 — Cloud‑Agnostic Modules  
Use modules that abstract:

- Naming  
- Tagging  
- Logging  
- Diagnostics  

Cloud‑specific modules implement the details.

---

## 30.6 Multi‑Cloud State Management

### 30.6.1 Separate State per Cloud

```
state-azure/
state-aws/
state-gcp/
```

### 30.6.2 Separate State per Module  
Avoid coupling.

### 30.6.3 Remote Backends per Cloud

- Azure Storage  
- AWS S3 + DynamoDB  
- GCP GCS  

### 30.6.4 Cross‑Cloud Dependencies via Outputs

Example:

Azure VNet → AWS Transit Gateway

Use:

- Remote state data sources  
- Outputs  
- Data lookups  

---

## 30.7 Multi‑Cloud Networking

Networking is the hardest part of multi‑cloud.

### 30.7.1 Common Patterns

#### Pattern 1 — VPN Mesh  
Each cloud connects to each other.

#### Pattern 2 — Hub‑and‑Spoke Across Clouds  
One cloud acts as the hub.

#### Pattern 3 — Cloud Interconnect Services  
Examples:

- Azure ExpressRoute + AWS Direct Connect  
- GCP Interconnect + AWS Direct Connect  

#### Pattern 4 — Third‑Party SD‑WAN  
Vendors like:

- Cisco  
- Palo Alto  
- Aviatrix  

Terraform supports all of these.

---

## 30.8 Multi‑Cloud Identity

Identity is the second hardest part.

### 30.8.1 Azure AD as Central Identity  
Use:

- Azure AD → AWS IAM federation  
- Azure AD → GCP IAM federation  

### 30.8.2 OIDC for CI/CD  
Use:

- GitHub → Azure  
- GitHub → AWS  
- GitHub → GCP  

### 30.8.3 Service Principals vs Roles  
Each cloud has different identity models.

---

## 30.9 Multi‑Cloud Security

Security must be consistent across clouds.

### 30.9.1 Policy as Code  
Use:

- OPA  
- Sentinel  
- Azure Policy  
- AWS Config  
- GCP Org Policies  

### 30.9.2 Encryption  
Enforce:

- CMK in Azure  
- KMS in AWS  
- CMEK in GCP  

### 30.9.3 Network Security  
Enforce:

- NSGs  
- Security groups  
- Firewall rules  

---

## 30.10 Multi‑Cloud Monitoring

Each cloud has its own monitoring system:

- Azure Monitor  
- AWS CloudWatch  
- GCP Cloud Monitoring  

Terraform can deploy:

- Log pipelines  
- Metric exporters  
- Centralized dashboards  
- SIEM integrations  

---

## 30.11 Multi‑Cloud CI/CD

### 30.11.1 Separate Pipelines per Cloud

```
deploy-azure.yml
deploy-aws.yml
deploy-gcp.yml
```

### 30.11.2 Shared Validation Pipeline  
Linting, formatting, security scanning.

### 30.11.3 OIDC Authentication  
No secrets required.

---

## 30.12 Multi‑Cloud Cost Optimization

Strategies:

- Right-size per cloud  
- Use spot/preemptible instances  
- Use reserved instances  
- Use tagging for cost allocation  
- Use cloud-native cost dashboards  

---

## 30.13 Real‑World Multi‑Cloud Architectures

### 30.13.1 Architecture 1 — Azure + AWS  
Azure for identity  
AWS for compute scale  

### 30.13.2 Architecture 2 — AWS + GCP  
AWS for general workloads  
GCP for analytics  

### 30.13.3 Architecture 3 — Azure + GCP  
Azure for enterprise workloads  
GCP for ML/AI  

### 30.13.4 Architecture 4 — Azure + AWS + GCP  
Used by global enterprises.

---

## 30.14 Multi‑Cloud Anti‑Patterns

### 30.14.1 Forcing Cloud-Agnostic Design  
Clouds are different — embrace differences.

### 30.14.2 Shared State Across Clouds  
Dangerous and fragile.

### 30.14.3 No Governance  
Multi‑cloud without governance is chaos.

### 30.14.4 Overly Complex Modules  
Avoid “one module to rule them all.”

---

## 30.15 Best Practices Summary

### Architecture  
- Use cloud‑specific modules  
- Use unified interfaces only when needed  
- Use separate state per cloud  

### Networking  
- Use hub‑and‑spoke or SD‑WAN  
- Avoid mesh unless necessary  

### Identity  
- Use Azure AD or OIDC federation  

### Security  
- Use Policy as Code  
- Enforce encryption everywhere  

### CI/CD  
- Use separate pipelines  
- Use OIDC authentication  

---

## 30.16 Summary

Multi‑cloud architectures are powerful but complex. Terraform provides the tooling to manage multi‑cloud infrastructure consistently and safely.  
Key takeaways:

- Multi‑cloud requires deliberate architecture  
- Terraform unifies providers, workflows, and modules  
- Use cloud‑specific modules with shared interfaces  
- Use separate state and pipelines per cloud  
- Networking and identity are the hardest parts  
- Governance, security, and monitoring must be consistent  
- Avoid anti‑patterns like cloud‑agnostic abstractions  

In the next chapter, we will explore **Terraform Enterprise and Terraform Cloud**, including workspaces, policy sets, remote execution, and enterprise workflows.
