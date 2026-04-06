# Chapter 28  
## Troubleshooting and Debugging

Even the most experienced Terraform practitioners encounter errors, unexpected behavior, and confusing edge cases. Terraform interacts with cloud APIs, state files, CI/CD systems, and modules — so failures can occur at many layers. Effective troubleshooting requires understanding how Terraform works internally, how providers behave, and how to interpret error messages.

This chapter provides a comprehensive guide to diagnosing and resolving Terraform issues, from simple syntax errors to complex state corruption and provider bugs.

---

## 28.1 The Terraform Troubleshooting Mindset

Troubleshooting Terraform requires:

- **Patience** — cloud APIs can be slow or inconsistent  
- **Systematic thinking** — isolate layers one by one  
- **Understanding of Terraform internals**  
- **Understanding of provider behavior**  
- **Awareness of state and dependency graphs**  

A structured approach prevents wasted time and accidental destructive actions.

---

## 28.2 Common Categories of Terraform Errors

Terraform errors fall into several categories:

1. **Syntax errors**  
2. **Validation errors**  
3. **Provider errors**  
4. **Authentication errors**  
5. **State errors**  
6. **Dependency graph errors**  
7. **Apply-time errors**  
8. **Drift-related errors**  
9. **CI/CD pipeline errors**  
10. **Module wiring errors**  

Each category requires a different debugging strategy.

---

## 28.3 Syntax Errors

Syntax errors occur before Terraform even evaluates resources.

### 28.3.1 Example

```
Error: Invalid argument name
```

### 28.3.2 Fix

Run:

```bash
terraform validate
terraform fmt -recursive
```

Common causes:

- Missing braces  
- Incorrect indentation  
- Typos in argument names  
- Incorrect HCL syntax  

---

## 28.4 Validation Errors

Validation errors occur when variable types or values are incorrect.

### 28.4.1 Example

```
Error: Invalid value for variable
```

### 28.4.2 Fix

Check:

- Variable types  
- Validation blocks  
- tfvars values  
- Required variables  

---

## 28.5 Provider Errors

Provider errors come from cloud APIs.

### 28.5.1 Example

```
Error: Error creating resource: 409 Conflict
```

### 28.5.2 Causes

- Resource already exists  
- API throttling  
- Incorrect permissions  
- Invalid SKU or region  

### 28.5.3 Fix

- Check provider documentation  
- Check cloud portal  
- Retry after throttling  
- Validate SKUs and regions  

---

## 28.6 Authentication Errors

Authentication errors occur when Terraform cannot authenticate to the cloud.

### 28.6.1 Example

```
Error: Error acquiring token
```

### 28.6.2 Fix

- Login with Azure CLI  
- Refresh AWS credentials  
- Fix GCP service account  
- Validate OIDC configuration  

---

## 28.7 State Errors

State errors are among the most dangerous.

### 28.7.1 Example

```
Error: Error locking state
```

### 28.7.2 Fix

- Wait for lock to expire  
- Use `terraform force-unlock` (carefully)  
- Check CI/CD pipeline logs  

### 28.7.3 Corrupted State

Symptoms:

- Missing resources  
- Invalid JSON  
- Unexpected diffs  

Fix:

- Restore from versioning  
- Rebuild state with imports  

---

## 28.8 Dependency Graph Errors

Terraform builds a dependency graph to determine resource order.

### 28.8.1 Example

```
Error: Cycle detected
```

### 28.8.2 Fix

- Remove circular dependencies  
- Use `depends_on` sparingly  
- Use outputs correctly  

---

## 28.9 Apply-Time Errors

Apply-time errors occur during resource creation.

### 28.9.1 Example

```
Error: Resource not found
```

### 28.9.2 Causes

- Race conditions  
- Missing dependencies  
- Incorrect resource IDs  

### 28.9.3 Fix

- Add explicit dependencies  
- Validate resource names  
- Check cloud portal  

---

## 28.10 Drift-Related Errors

Drift occurs when infrastructure changes outside Terraform.

### 28.10.1 Example

```
Error: Resource already exists
```

### 28.10.2 Fix

- Import resource  
- Update configuration  
- Reconcile drift manually  

---

## 28.11 CI/CD Pipeline Errors

Pipeline errors often involve:

- Missing environment variables  
- Incorrect working directory  
- Missing backend configuration  
- Incorrect OIDC permissions  
- Missing tfvars  

### 28.11.1 Example

```
Error: Backend configuration block not found
```

### 28.11.2 Fix

- Validate backend file  
- Validate pipeline path  
- Validate secrets  

---

## 28.12 Module Wiring Errors

Module wiring errors occur when:

- Inputs are missing  
- Outputs are incorrect  
- Types mismatch  
- Modules reference wrong paths  

### 28.12.1 Example

```
Error: Unsupported attribute
```

### 28.12.2 Fix

- Check module outputs  
- Check variable types  
- Check module source paths  

---

## 28.13 Debugging Techniques

### 28.13.1 Use Terraform Debug Logs

Enable debug logs:

```bash
export TF_LOG=DEBUG
terraform apply
```

### 28.13.2 Use Terraform Graph

Generate dependency graph:

```bash
terraform graph | dot -Tpng > graph.png
```

### 28.13.3 Use `terraform state show`

Inspect resource state:

```bash
terraform state show azurerm_storage_account.sa
```

### 28.13.4 Use `terraform console`

Evaluate expressions interactively:

```bash
terraform console
```

---

## 28.14 Debugging Provider Issues

### 28.14.1 Check Provider Versions

```bash
terraform providers
```

### 28.14.2 Pin Provider Versions

```hcl
required_providers {
  azurerm = {
    version = "~> 4.0"
  }
}
```

### 28.14.3 Check Provider Changelog  
Providers often introduce breaking changes.

---

## 28.15 Debugging State Issues

### 28.15.1 List Resources

```bash
terraform state list
```

### 28.15.2 Show Resource

```bash
terraform state show <resource>
```

### 28.15.3 Remove Resource (Dangerous)

```bash
terraform state rm <resource>
```

### 28.15.4 Move Resource

```bash
terraform state mv <old> <new>
```

---

## 28.16 Debugging CI/CD Issues

### 28.16.1 Validate Working Directory  
Ensure pipeline runs in correct folder.

### 28.16.2 Validate Backend Access  
Check:

- RBAC  
- IAM  
- OIDC  

### 28.16.3 Validate Secrets  
Ensure required secrets exist.

### 28.16.4 Validate tfvars  
Ensure correct tfvars are passed.

---

## 28.17 Debugging Naming and Tagging Issues

Use locals to standardize naming:

```hcl
locals {
  name = "${var.prefix}-${var.environment}-${var.component}"
}
```

Debug by printing locals:

```bash
terraform console
> local.name
```

---

## 28.18 Debugging Performance Issues

### 28.18.1 Causes

- Large state files  
- Slow cloud APIs  
- Too many resources  
- Complex dependency graphs  

### 28.18.2 Fixes

- Split modules  
- Use data sources sparingly  
- Use remote state  
- Use provider timeouts  

---

## 28.19 Troubleshooting Anti‑Patterns

### 28.19.1 Editing State Manually  
Never do this.

### 28.19.2 Using Force-Unlock Without Checking  
Can corrupt state.

### 28.19.3 Ignoring Provider Errors  
They often indicate real issues.

### 28.19.4 Ignoring Drift  
Leads to unpredictable behavior.

### 28.19.5 Using `-auto-approve` in Prod  
Dangerous.

---

## 28.20 Best Practices Summary

### Debugging  
- Use logs  
- Use console  
- Use graph  
- Use state commands  

### State  
- Never edit manually  
- Use versioning  
- Use remote state  

### Providers  
- Pin versions  
- Read changelogs  

### CI/CD  
- Validate paths  
- Validate secrets  
- Validate OIDC  

### Modules  
- Validate inputs  
- Validate outputs  
- Validate types  

---

## 28.21 Summary

Troubleshooting Terraform requires understanding how Terraform interacts with providers, state, modules, and pipelines.  
Key takeaways:

- Errors fall into predictable categories  
- Debugging requires systematic isolation  
- State issues are the most dangerous  
- Provider errors often reflect cloud API behavior  
- CI/CD issues often involve paths, permissions, or secrets  
- Tools like `terraform console`, `graph`, and debug logs are invaluable  
- Avoid anti-patterns like manual state edits or force-unlock misuse  

In the next chapter, we will explore **Terraform Advanced Patterns**, including dynamic blocks, for_each strategies, complex object types, and advanced module composition.
