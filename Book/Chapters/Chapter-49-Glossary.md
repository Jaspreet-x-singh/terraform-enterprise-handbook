# Chapter 49  
## Glossary

This glossary provides clear, concise definitions of key Terraform and cloud‑infrastructure terms used throughout this book. It serves as a quick reference for beginners and experts alike, ensuring consistent understanding of core concepts.

---

## A

### Apply  
The Terraform command that executes changes to create, update, or destroy infrastructure.

### Argument  
A configuration value inside a resource or module block.

### Attribute  
An output value exposed by a resource (e.g., `id`, `name`, `location`).

### AzureRM Provider  
The Terraform provider used to manage Azure resources.

---

## B

### Backend  
The storage location for Terraform state (Azure Storage, S3, GCS, Terraform Cloud).

### Bicep  
A domain-specific language for Azure deployments; sometimes migrated to Terraform.

### Block  
A structural element in HCL (e.g., `resource`, `module`, `variable`).

---

## C

### CI/CD  
Continuous Integration / Continuous Deployment pipelines used to automate Terraform workflows.

### Cloud Provider  
A platform such as Azure, AWS, or GCP that Terraform interacts with.

### Count  
A meta‑argument used to create multiple instances of a resource.

---

## D

### Data Source  
A read‑only lookup that fetches information from a provider.

### Dependency Graph  
Terraform’s internal model of resource relationships.

### Drift  
When real infrastructure differs from Terraform state due to manual changes.

---

## E

### Environment  
A deployment context such as dev, test, or prod.

### Execution Plan  
The output of `terraform plan`, showing proposed changes.

---

## F

### For_each  
A meta‑argument used to create multiple resources with stable addressing.

### Feature Flags  
Provider-level toggles that enable or disable experimental features.

---

## G

### GitOps  
A workflow where Git is the source of truth for infrastructure changes.

### Governance  
Policies and controls that enforce standards across Terraform deployments.

---

## H

### HCL (HashiCorp Configuration Language)  
The language used to write Terraform configurations.

### Hub-and-Spoke  
A common enterprise network architecture pattern.

---

## I

### IaC (Infrastructure as Code)  
Managing infrastructure using code instead of manual processes.

### Import  
The process of adopting existing resources into Terraform state.

### Input Variable  
A parameter passed into a module or root module.

---

## J

### JSON  
A data format sometimes used for Terraform plans or external data.

---

## K

### Key Vault / Secrets Manager  
A secure store for secrets used by Terraform.

### Kubernetes Provider  
A provider used to manage Kubernetes resources.

---

## L

### Landing Zone  
A standardized cloud foundation with identity, networking, logging, and governance.

### Lifecycle Block  
A block that controls resource behavior (e.g., `prevent_destroy`, `ignore_changes`).

### Local Values  
Computed values used within a module.

---

## M

### Managed Identity / IAM Role  
Identity mechanisms used by Terraform for authentication.

### Module  
A reusable collection of Terraform resources.

### Module Registry  
A repository for publishing and consuming modules.

---

## N

### Naming Convention  
A standardized pattern for naming resources.

### Null Resource  
A resource used for orchestration or running scripts.

---

## O

### OIDC (OpenID Connect)  
A secure, secretless authentication method for CI/CD pipelines.

### Output  
A value exposed by a module for use by other modules or pipelines.

### OPA (Open Policy Agent)  
A policy engine used for governance.

---

## P

### Plan  
A preview of changes Terraform will apply.

### Policy as Code  
Governance rules written in code (Sentinel, OPA, Azure Policy).

### Provider  
A plugin that allows Terraform to interact with APIs.

---

## Q

### Quota  
A cloud provider limit on resource usage.

---

## R

### Remote State  
State stored in a backend with locking and versioning.

### Resource  
A block that defines a piece of infrastructure.

### Root Module  
The top-level module representing an environment.

---

## S

### Secret  
Sensitive information that must not be stored in code or state.

### Sentinel  
HashiCorp’s policy-as-code framework.

### State  
Terraform’s record of managed infrastructure.

### State Locking  
A mechanism preventing concurrent state modifications.

### Submodule  
A module called by another module.

---

## T

### Tagging  
Metadata applied to resources for cost allocation and governance.

### Terraform Cloud  
A managed service for Terraform state, execution, and governance.

### Terraform Enterprise  
The self-hosted version of Terraform Cloud.

### Terraform Registry  
A public or private repository of modules and providers.

### Terratest  
A Go-based testing framework for Terraform.

---

## U

### Unit Test  
A test that validates module logic without deploying resources.

### Upgrade  
Updating provider or module versions.

---

## V

### Variable  
An input parameter for modules or root modules.

### Version Pinning  
Locking provider or module versions to avoid unexpected changes.

### VNet / VPC  
Virtual networks in Azure and AWS.

---

## W

### Workspace  
A Terraform Cloud construct for managing state and runs.

### Workflow  
A sequence of steps for deploying infrastructure.

---

## X

### YAML  
A configuration format sometimes used for CI/CD pipelines.

---

## Y

### YAML Pipeline  
A pipeline defined using YAML syntax (GitHub Actions, Azure DevOps).

---

## Z

### Zero‑Trust  
A security model that assumes no implicit trust and enforces strict identity-based access.

---

# 49.1 Summary

This glossary provides a comprehensive reference for Terraform terminology used throughout the book. It supports:

- Faster onboarding  
- Clearer communication  
- Better collaboration  
- Stronger understanding of Terraform concepts  

In the next chapter, we will conclude the book with **Chapter 50 — Final Thoughts & Next Steps**, wrapping up the journey and outlining how to continue mastering Terraform.
