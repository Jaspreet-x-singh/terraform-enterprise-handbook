# Chapter 22  
## Terraform for Teams

Terraform becomes exponentially more powerful — and more complex — when used by teams. Collaboration introduces challenges around code ownership, branching strategies, reviews, governance, access control, and shared state. Without a clear team strategy, Terraform can quickly devolve into chaos.

This chapter explores how teams can collaborate effectively with Terraform, how to structure repositories, how to manage access, and how to build workflows that scale across organizations.

---

## 22.1 Why Terraform Collaboration Is Hard

Teams face several challenges:

- **Shared state** requires careful locking and access control  
- **Multiple contributors** can introduce conflicting changes  
- **Different environments** require isolation  
- **Code reviews** must ensure safety and compliance  
- **Pipelines** must be consistent across modules  
- **Governance** must prevent unsafe changes  
- **Knowledge gaps** can lead to misconfigurations  

Terraform for teams is as much about **process** as it is about **technology**.

---

## 22.2 Collaboration Models

There are three primary collaboration models:

### 22.2.1 Model 1 — Central Platform Team (Most Common)

A central team:

- Builds modules  
- Maintains CI/CD pipelines  
- Enforces standards  
- Provides guidance  

Application teams:

- Consume modules  
- Provide environment-specific variables  
- Request new features  

### 22.2.2 Model 2 — Federated Ownership

Each team owns:

- Its own modules  
- Its own pipelines  
- Its own environments  

A platform team provides:

- Governance  
- Security  
- Shared tooling  

### 22.2.3 Model 3 — Fully Decentralized

Each team:

- Builds its own modules  
- Manages its own state  
- Manages its own pipelines  

This model is rare and risky without strong governance.

---

## 22.3 Repository Structures for Teams

### 22.3.1 Structure 1 — Monorepo (Recommended for Medium Teams)

```
infrastructure/
  modules/
  environments/
  pipelines/
```

Benefits:

- Easy to share modules  
- Easy to enforce standards  
- Single source of truth  

### 22.3.2 Structure 2 — Multi-Repo (Recommended for Large Enterprises)

```
repo-modules-network
repo-modules-compute
repo-modules-security
repo-infra-dev
repo-infra-prod
```

Benefits:

- Clear ownership  
- Independent pipelines  
- Scales across teams  

### 22.3.3 Structure 3 — Hybrid

Modules in one repo, environments in another.

---

## 22.4 Branching Strategies

### 22.4.1 Strategy 1 — GitFlow

```
feature → develop → release → main
```

Good for:

- Complex workflows  
- Large teams  

### 22.4.2 Strategy 2 — Trunk-Based Development (Recommended)

```
feature → main
```

Benefits:

- Fast  
- Simple  
- Works well with CI/CD  

### 22.4.3 Strategy 3 — Environment Branches

```
dev → test → prod
```

Used in GitOps workflows.

---

## 22.5 Code Review Best Practices

### 22.5.1 Review for Safety

Check for:

- Accidental deletions  
- Resource replacements  
- Missing lifecycle rules  
- Hardcoded values  

### 22.5.2 Review for Standards

Check:

- Naming conventions  
- Tagging  
- Diagnostics  
- Security settings  

### 22.5.3 Review for Maintainability

Check:

- Module usage  
- Variable types  
- Locals  
- Comments  

### 22.5.4 Review for Drift

Ensure:

- No manual portal changes  
- No unexpected differences  

---

## 22.6 Access Control for Teams

### 22.6.1 State Access

Only allow:

- Platform engineers  
- CI/CD pipelines  

Never allow:

- Application developers  
- Contractors  
- External systems  

### 22.6.2 Backend Access

Use:

- Azure RBAC  
- AWS IAM  
- GCP IAM  

### 22.6.3 Repository Access

Use:

- Branch protection  
- Required reviews  
- Required checks  

---

## 22.7 Secrets and Identity for Teams

### 22.7.1 Use OIDC for CI/CD

Eliminates:

- Client secrets  
- Key rotation  
- Secret leaks  

### 22.7.2 Use Secret Managers

- Azure Key Vault  
- AWS Secrets Manager  
- GCP Secret Manager  

### 22.7.3 Never Store Secrets in Repos

Even in private repos.

---

## 22.8 Team Workflows

### 22.8.1 Workflow 1 — Module Development

1. Create feature branch  
2. Add module logic  
3. Add validation  
4. Add documentation  
5. Add Terratest  
6. Open PR  
7. Review  
8. Merge  
9. Tag release  

### 22.8.2 Workflow 2 — Environment Deployment

1. Update tfvars  
2. Open PR  
3. Pipeline runs plan  
4. Review plan  
5. Approve  
6. Apply via pipeline  

### 22.8.3 Workflow 3 — Promotion Workflow

1. Deploy to dev  
2. Validate  
3. Promote to test  
4. Validate  
5. Promote to prod  

---

## 22.9 Team Governance

Governance includes:

- Policy as Code  
- Approval gates  
- Security scanning  
- Naming enforcement  
- Tagging enforcement  
- Module versioning  
- Access control  

Governance ensures:

- Compliance  
- Security  
- Consistency  

---

## 22.10 Documentation for Teams

Teams must document:

- Module usage  
- Naming conventions  
- Tagging standards  
- CI/CD workflows  
- Environment structure  
- Promotion workflows  
- Access control  
- Troubleshooting  

Good documentation reduces onboarding time and prevents mistakes.

---

## 22.11 Common Team Anti-Patterns

### 22.11.1 Everyone Modifies Everything  
Leads to chaos.

### 22.11.2 No Module Ownership  
Modules become unmaintained.

### 22.11.3 No Code Reviews  
Mistakes slip into production.

### 22.11.4 Shared State Across Environments  
Dangerous and fragile.

### 22.11.5 Manual Portal Changes  
Creates drift and outages.

---

## 22.12 Best Practices for Terraform Teams

### 22.12.1 Use a Platform Team  
Centralized governance.

### 22.12.2 Use Module Ownership  
Clear accountability.

### 22.12.3 Use CI/CD Everywhere  
No manual applies.

### 22.12.4 Use GitOps Promotion  
Predictable deployments.

### 22.12.5 Use Environment Isolation  
Separate state and pipelines.

### 22.12.6 Use Policy as Code  
Automated compliance.

### 22.12.7 Use Documentation  
Reduce tribal knowledge.

---

## 22.13 Summary

Terraform for teams requires more than writing code — it requires structure, governance, and collaboration.  
Key takeaways:

- Use clear collaboration models  
- Use monorepo or multi-repo structures  
- Use trunk-based development or GitFlow  
- Use code reviews for safety and standards  
- Use strict access control for state and backends  
- Use OIDC and secret managers  
- Use CI/CD pipelines for all deployments  
- Use governance and documentation to scale  

In the next chapter, we will explore **Terraform Governance and Policy as Code**, including Sentinel, OPA, Azure Policy, and enterprise compliance patterns.
