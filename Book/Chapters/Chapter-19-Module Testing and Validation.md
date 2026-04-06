# Chapter 19  
## Module Testing and Validation

Writing Terraform modules is only half the job — ensuring they work reliably, consistently, and safely across environments is the other half. Testing and validation are essential for building production-grade infrastructure. They help catch errors early, enforce standards, and prevent regressions when modules evolve.

This chapter explores the full spectrum of Terraform testing and validation techniques, from basic syntax checks to automated Terratest suites and CI/CD validation pipelines.

---

## 19.1 Why Test Terraform Modules?

Infrastructure failures can be catastrophic. Testing modules helps prevent:

- Misconfigurations  
- Breaking changes  
- Invalid inputs  
- Security gaps  
- Drift-related issues  
- Regression bugs  

Testing ensures:

- Predictability  
- Stability  
- Compliance  
- Confidence in deployments  

---

## 19.2 Types of Terraform Testing

Terraform supports several layers of testing:

1. **Static validation**  
2. **Linting**  
3. **Unit testing (Terratest)**  
4. **Integration testing**  
5. **End-to-end testing**  
6. **CI/CD validation pipelines**  

Each layer catches different classes of issues.

---

## 19.3 Static Validation

### 19.3.1 `terraform validate`

Checks:

- Syntax  
- Types  
- Provider configuration  
- Module structure  

Run:

```bash
terraform validate
```

### 19.3.2 `terraform fmt`

Formats code:

```bash
terraform fmt -recursive
```

Ensures consistent formatting across teams.

---

## 19.4 Linting with TFLint

TFLint is a powerful linter for Terraform.

### 19.4.1 What TFLint Checks

- Invalid resource arguments  
- Deprecated arguments  
- Naming conventions  
- Provider-specific rules  
- Security issues  
- Best practices  

### 19.4.2 Installing TFLint

```bash
brew install tflint
```

### 19.4.3 Running TFLint

```bash
tflint
```

### 19.4.4 Custom Rules

TFLint supports:

- AzureRM rules  
- AWS rules  
- GCP rules  
- Custom enterprise rules  

---

## 19.5 Linting with Checkov

Checkov is a security-focused IaC scanner.

### 19.5.1 What Checkov Detects

- Security misconfigurations  
- Missing encryption  
- Public exposure  
- Weak authentication  
- Compliance violations  

Run:

```bash
checkov -d .
```

---

## 19.6 Unit Testing with Terratest

Terratest is a Go-based testing framework for Terraform.

### 19.6.1 Why Terratest?

Terratest allows you to:

- Deploy real infrastructure  
- Validate outputs  
- Run assertions  
- Destroy resources automatically  

### 19.6.2 Example Terratest

```go
func TestNetworkModule(t *testing.T) {
  terraformOptions := &terraform.Options{
    TerraformDir: "../modules/network",
  }

  defer terraform.Destroy(t, terraformOptions)
  terraform.InitAndApply(t, terraformOptions)

  vnetId := terraform.Output(t, terraformOptions, "vnet_id")
  assert.NotEmpty(t, vnetId)
}
```

### 19.6.3 Test Lifecycle

1. Init  
2. Apply  
3. Validate  
4. Destroy  

Terratest is ideal for:

- Critical modules  
- Complex logic  
- Production-grade infrastructure  

---

## 19.7 Integration Testing

Integration tests validate how modules work together.

Example:

- Network + Subnets  
- VM + NIC + NSG  
- AKS + VNet + Log Analytics  

Integration tests catch:

- Dependency issues  
- Incorrect outputs  
- Misaligned interfaces  

---

## 19.8 End-to-End Testing

End-to-end tests validate:

- Full environment deployments  
- CI/CD workflows  
- Remote state wiring  
- Module composition  

These tests are typically run:

- Nightly  
- Before major releases  
- Before production deployments  

---

## 19.9 Testing in CI/CD Pipelines

A production-grade pipeline includes:

### 19.9.1 Stage 1 — Format

```bash
terraform fmt -check -recursive
```

### 19.9.2 Stage 2 — Validate

```bash
terraform validate
```

### 19.9.3 Stage 3 — Lint

```bash
tflint
checkov -d .
```

### 19.9.4 Stage 4 — Plan

```bash
terraform plan
```

### 19.9.5 Stage 5 — Manual Approval  
Required for production.

### 19.9.6 Stage 6 — Apply

```bash
terraform apply -auto-approve
```

---

## 19.10 Testing Module Interfaces

### 19.10.1 Validate Required Inputs  
Ensure required variables have no defaults.

### 19.10.2 Validate Optional Inputs  
Use `nullable = false` when appropriate.

### 19.10.3 Validate Types  
Use strict types:

```hcl
type = object({
  name = string
  cidr = string
})
```

### 19.10.4 Validate Outputs  
Ensure outputs:

- Exist  
- Are correct  
- Are stable  

---

## 19.11 Testing Naming Conventions

Use locals to enforce naming:

```hcl
locals {
  name = "${var.prefix}-${var.environment}-${var.component}"
}
```

Test:

- Length  
- Format  
- Uniqueness  

---

## 19.12 Testing Diagnostics and Logging

Modules should enforce:

- Diagnostic settings  
- Log analytics workspace IDs  
- Monitoring integrations  

Test:

- Required logs exist  
- Categories are correct  
- Retention is set  

---

## 19.13 Testing Security Controls

Test:

- NSG rules  
- Firewall rules  
- Encryption settings  
- Identity assignments  
- Key Vault access policies  

Security tests are essential for production modules.

---

## 19.14 Testing Error Handling

Modules should:

- Fail fast  
- Provide clear validation errors  
- Prevent invalid configurations  

Example validation:

```hcl
validation {
  condition     = var.sku != "Premium" || var.environment == "prod"
  error_message = "Premium SKU is only allowed in production."
}
```

---

## 19.15 Testing Module Upgrades

When upgrading modules:

- Run Terratest  
- Run integration tests  
- Run plan-only pipelines  
- Compare outputs  
- Validate backward compatibility  

---

## 19.16 Best Practices for Module Testing

### 19.16.1 Automate Everything  
Manual testing is error-prone.

### 19.16.2 Test Every Module  
Even simple modules.

### 19.16.3 Use Terratest for Critical Modules  
Especially networking, security, and compute.

### 19.16.4 Use Linting and Security Scans  
Catch issues early.

### 19.16.5 Test Naming and Tagging  
Enforce standards.

### 19.16.6 Test Module Interfaces  
Inputs and outputs must be stable.

### 19.16.7 Test in CI/CD  
Never rely on local testing alone.

---

## 19.17 Summary

Module testing and validation are essential for building reliable, secure, and scalable Terraform infrastructure.  
Key takeaways:

- Use `validate` and `fmt` for basic checks  
- Use TFLint and Checkov for linting and security  
- Use Terratest for real infrastructure testing  
- Use integration and end-to-end tests for complex systems  
- Use CI/CD pipelines to automate validation  
- Test naming, tagging, diagnostics, and security  
- Test module interfaces and upgrades  

In the next chapter, we will explore **Terraform CI/CD pipelines**, including GitHub Actions, Azure DevOps, and enterprise deployment patterns.
