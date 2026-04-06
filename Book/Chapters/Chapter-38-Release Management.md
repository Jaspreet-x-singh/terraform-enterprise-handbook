# Chapter 38  
## Release Management

Release management is the discipline of planning, versioning, validating, and promoting Terraform changes across environments in a controlled, predictable, and auditable manner. In large organizations, Terraform is not just code — it is infrastructure. That means every change must follow a rigorous release process to ensure safety, compliance, and operational stability.

This chapter explores module versioning, environment promotion, release pipelines, semantic versioning, change control, and enterprise release governance.

---

## 38.1 Why Release Management Matters

Terraform release management ensures:

- **Predictability** — changes behave consistently across environments  
- **Safety** — breaking changes are caught early  
- **Governance** — approvals and audits are enforced  
- **Stability** — production environments remain reliable  
- **Traceability** — every change is documented and reviewable  
- **Scalability** — multiple teams can deploy safely  

Without release management, Terraform becomes chaotic and risky.

---

## 38.2 Release Management Components

A complete Terraform release process includes:

1. **Version control**  
2. **Semantic versioning**  
3. **Module versioning**  
4. **Environment promotion**  
5. **Release pipelines**  
6. **Approvals and governance**  
7. **Testing and validation**  
8. **Documentation and change logs**  

Each component contributes to a safe and scalable release workflow.

---

## 38.3 Semantic Versioning for Terraform Modules

Semantic versioning (SemVer) is essential for module stability.

### 38.3.1 Version Format

```
MAJOR.MINOR.PATCH
```

### 38.3.2 Meaning

- **MAJOR** — breaking changes  
- **MINOR** — new features, backward compatible  
- **PATCH** — bug fixes, no new features  

### 38.3.3 Examples

- `1.0.0` — initial stable release  
- `1.1.0` — new optional input added  
- `2.0.0` — breaking change introduced  

### 38.3.4 When to Bump Versions

| Change Type | Version Bump |
|-------------|--------------|
| New optional variable | MINOR |
| New output | MINOR |
| Bug fix | PATCH |
| Rename variable | MAJOR |
| Change default value (breaking) | MAJOR |
| Remove variable | MAJOR |

---

## 38.4 Module Release Workflow

A typical module release workflow:

### 38.4.1 Step 1 — Developer Makes Changes  
Changes are made in a feature branch.

### 38.4.2 Step 2 — Pull Request  
Includes:

- Code changes  
- Updated README  
- Updated examples  
- Updated version  

### 38.4.3 Step 3 — Automated Tests  
Pipeline runs:

- fmt  
- validate  
- tflint  
- checkov  
- terratest (optional)  

### 38.4.4 Step 4 — Review and Approval  
Senior engineers or platform team approve.

### 38.4.5 Step 5 — Merge to Main  
Triggers release pipeline.

### 38.4.6 Step 6 — Tag Release  
Example:

```
git tag v1.3.0
git push origin v1.3.0
```

### 38.4.7 Step 7 — Publish to Module Registry  
Terraform Cloud or internal registry.

---

## 38.5 Root Module Release Workflow

Root modules represent environments.

### 38.5.1 Dev → Test → Prod Promotion

Typical workflow:

1. Deploy to **dev**  
2. Validate  
3. Promote to **test**  
4. Validate  
5. Promote to **prod**  

### 38.5.2 Promotion Methods

- GitOps (branch-based)  
- Tag-based promotion  
- Manual promotion via pipelines  
- Terraform Cloud workspace promotion  

### 38.5.3 Promotion Requirements

- Successful plan  
- Successful tests  
- Approval gates  
- Policy checks  
- No drift  

---

## 38.6 Release Pipelines

Release pipelines enforce consistency.

### 38.6.1 Pipeline Stages

1. **Linting**  
2. **Validation**  
3. **Security scanning**  
4. **Plan**  
5. **Policy checks**  
6. **Approval**  
7. **Apply**  
8. **Post-deployment tests**  

### 38.6.2 Manual Approval Gates

Required for:

- Production  
- Sensitive resources  
- Networking changes  
- Identity changes  

### 38.6.3 Plan Files

Use plan files to ensure consistency:

```bash
terraform plan -out=tfplan
terraform apply tfplan
```

---

## 38.7 Change Control and Governance

### 38.7.1 Change Advisory Board (CAB)

CAB reviews:

- High-risk changes  
- Production changes  
- Breaking changes  

### 38.7.2 ITSM Integration

Integrate with:

- ServiceNow  
- Jira  
- Remedy  

Automate:

- Change requests  
- Approvals  
- Audit logs  

### 38.7.3 Policy as Code

Use:

- Sentinel  
- OPA  
- Azure Policy  
- AWS Config  

Policies enforce:

- Tagging  
- Naming  
- Encryption  
- Region restrictions  
- SKU restrictions  

---

## 38.8 Release Documentation

Every release should include:

### 38.8.1 Changelog

Example:

```
## v1.4.0
- Added support for private endpoints
- Added new output: private_endpoint_id
- Fixed bug in subnet calculation
```

### 38.8.2 Release Notes

Include:

- Breaking changes  
- Migration instructions  
- New features  
- Bug fixes  

### 38.8.3 Architecture Impact Notes  
Document:

- New dependencies  
- New resources  
- New risks  

---

## 38.9 Release Testing

### 38.9.1 Unit Tests  
Validate module logic.

### 38.9.2 Integration Tests  
Validate resource creation.

### 38.9.3 End-to-End Tests  
Validate full environment.

### 38.9.4 Policy Tests  
Validate governance.

### 38.9.5 Performance Tests  
Validate plan/apply speed.

---

## 38.10 Rollback Strategies

### 38.10.1 Rollback Module Version  
Update version in root module:

```hcl
version = "1.3.0"
```

### 38.10.2 Rollback State  
Use backend versioning.

### 38.10.3 Rollback Environment  
Redeploy previous commit.

### 38.10.4 Rollback Pipelines  
Restore previous pipeline version.

---

## 38.11 Anti-Patterns

### 38.11.1 No Versioning  
Impossible to track changes.

### 38.11.2 Direct Commits to Main  
Bypasses governance.

### 38.11.3 No Approval Gates  
Risky for production.

### 38.11.4 No Changelogs  
Hard to understand changes.

### 38.11.5 No Testing  
High risk of outages.

---

## 38.12 Best Practices Summary

### Versioning  
- Use semantic versioning  
- Tag releases  
- Publish to registry  

### Promotion  
- Use dev → test → prod  
- Use approval gates  
- Use plan files  

### Governance  
- Use policy as code  
- Use ITSM integration  
- Use CAB for high-risk changes  

### Documentation  
- Use changelogs  
- Use release notes  
- Use architecture impact notes  

---

## 38.13 Summary

Release management is essential for safe, predictable, and scalable Terraform operations.  
Key takeaways:

- Use semantic versioning for modules  
- Use structured promotion workflows  
- Use release pipelines with approvals  
- Use policy as code for governance  
- Use changelogs and documentation  
- Avoid anti-patterns like direct commits or no testing  

In the next chapter, we will explore **Terraform Architecture Patterns**, including hub‑and‑spoke, landing zones, multi‑region deployments, and enterprise network topologies.
