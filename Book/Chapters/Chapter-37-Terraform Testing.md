# Chapter 37  
## Terraform Testing

Testing is a critical part of any mature infrastructure‑as‑code workflow. Without testing, Terraform configurations can introduce outages, security vulnerabilities, misconfigurations, and regressions — often without warning. Testing ensures that infrastructure behaves as expected, modules remain stable, and changes are safe to deploy.

This chapter explores the full spectrum of Terraform testing, including unit tests, integration tests, Terratest, policy tests, CI/CD validation, and environment-level verification.

---

## 37.1 Why Testing Matters in Terraform

Testing provides:

- **Safety** — prevent breaking changes  
- **Predictability** — ensure consistent behavior  
- **Governance** — enforce standards  
- **Confidence** — deploy with reduced risk  
- **Quality** — catch issues early  
- **Scalability** — support multi-team environments  

Testing is essential for production-grade Terraform.

---

## 37.2 Types of Terraform Tests

Terraform supports several testing layers:

1. **Static tests**  
2. **Unit tests**  
3. **Integration tests**  
4. **End-to-end tests**  
5. **Policy tests**  
6. **Security tests**  
7. **CI/CD validation tests**  

Each layer serves a different purpose.

---

## 37.3 Static Testing

Static testing validates Terraform code without deploying anything.

### 37.3.1 terraform fmt  
Ensures consistent formatting.

```bash
terraform fmt -recursive
```

### 37.3.2 terraform validate  
Validates syntax and structure.

```bash
terraform validate
```

### 37.3.3 TFLint  
Linting for:

- Naming  
- Deprecated arguments  
- Provider issues  

### 37.3.4 Checkov / tfsec  
Security scanning for:

- Public access  
- Missing encryption  
- Missing tags  
- Insecure configurations  

Static testing is the first line of defense.

---

## 37.4 Unit Testing Terraform Modules

Unit tests validate module logic without deploying resources.

### 37.4.1 Tools for Unit Testing

- **terraform validate**  
- **terraform plan (mocked)**  
- **OPA/Rego tests**  
- **Kitchen-Terraform (legacy)**  

### 37.4.2 What to Test in Unit Tests

- Variable validation  
- Naming conventions  
- Tag merging  
- Conditional logic  
- Dynamic blocks  
- Output correctness  

### 37.4.3 Example: Validate Naming Convention

```hcl
validation {
  condition     = can(regex("^app-[a-z0-9-]+$", var.name))
  error_message = "Name must follow the app-xxx pattern."
}
```

Unit tests ensure modules behave correctly before integration.

---

## 37.5 Integration Testing with Terratest

Terratest is the industry-standard tool for Terraform integration testing.

### 37.5.1 What Terratest Does

- Deploys real infrastructure  
- Validates outputs  
- Runs assertions  
- Destroys resources after tests  

### 37.5.2 Example Terratest Structure

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

### 37.5.3 What to Test with Terratest

- Resource creation  
- Outputs  
- Networking  
- IAM/RBAC  
- Diagnostics  
- Connectivity  

Terratest provides high confidence in module correctness.

---

## 37.6 End-to-End Testing

End-to-end tests validate entire environments.

### 37.6.1 What to Test

- Full environment deployment  
- Cross-module dependencies  
- Networking flows  
- Identity flows  
- Monitoring and diagnostics  
- Application connectivity  

### 37.6.2 When to Use E2E Tests

- Before production releases  
- Before major module upgrades  
- Before provider upgrades  

E2E tests are expensive but essential for critical systems.

---

## 37.7 Policy Testing

Policy testing ensures governance rules are enforced.

### 37.7.1 Sentinel Tests

Example:

```hcl
test {
  rule = "require_tags"
  input = "testdata/plan.json"
  expect_fail = true
}
```

### 37.7.2 OPA/Rego Tests

Example:

```rego
test_no_public_ip {
  not allow_public_ip with input as test_input
}
```

Policy tests ensure compliance and security.

---

## 37.8 Security Testing

Security testing includes:

- Checkov  
- tfsec  
- OPA policies  
- Sentinel policies  
- Secret scanning  
- Drift detection  

Security tests prevent vulnerabilities from reaching production.

---

## 37.9 CI/CD Validation Testing

CI/CD pipelines must include:

### 37.9.1 Formatting  
`terraform fmt`

### 37.9.2 Validation  
`terraform validate`

### 37.9.3 Linting  
TFLint

### 37.9.4 Security Scanning  
Checkov / tfsec

### 37.9.5 Plan Review  
Human approval required.

### 37.9.6 Policy Checks  
OPA / Sentinel

### 37.9.7 Apply  
Only after approval.

CI/CD is the enforcement layer for testing.

---

## 37.10 Testing Provider Upgrades

Provider upgrades can break infrastructure.

### 37.10.1 Strategy

1. Test in dev  
2. Run Terratest  
3. Run E2E tests  
4. Validate plan  
5. Promote to test  
6. Promote to prod  

### 37.10.2 Pin Provider Versions

```hcl
required_providers {
  azurerm = {
    version = "~> 4.0"
  }
}
```

---

## 37.11 Testing Module Upgrades

Module upgrades must be tested before promotion.

### 37.11.1 Strategy

1. Run unit tests  
2. Run Terratest  
3. Run integration tests  
4. Run E2E tests  
5. Validate plan  
6. Promote to higher environments  

### 37.11.2 Semantic Versioning

- MAJOR — breaking changes  
- MINOR — new features  
- PATCH — bug fixes  

---

## 37.12 Testing Environment Promotion

Promotion workflow:

1. Deploy to dev  
2. Run tests  
3. Promote to test  
4. Run tests  
5. Promote to prod  

Testing ensures consistency across environments.

---

## 37.13 Testing Anti-Patterns

### 37.13.1 No Testing  
High risk.

### 37.13.2 Testing Only in Prod  
Dangerous.

### 37.13.3 No Terratest  
Misses integration issues.

### 37.13.4 No Policy Testing  
Governance gaps.

### 37.13.5 No CI/CD Validation  
Human error risk.

---

## 37.14 Best Practices Summary

### Unit Tests  
- Validate logic  
- Validate naming  
- Validate variables  

### Integration Tests  
- Use Terratest  
- Validate outputs  
- Validate connectivity  

### Policy Tests  
- Use Sentinel  
- Use OPA  

### Security Tests  
- Use Checkov  
- Use tfsec  

### CI/CD  
- Enforce validation  
- Enforce scanning  
- Enforce approvals  

---

## 37.15 Summary

Testing is essential for reliable, secure, and scalable Terraform deployments.  
Key takeaways:

- Use static tests for fast feedback  
- Use unit tests to validate module logic  
- Use Terratest for integration testing  
- Use E2E tests for environment validation  
- Use policy tests for governance  
- Use CI/CD validation for enforcement  
- Avoid anti-patterns like skipping tests or testing only in production  

In the next chapter, we will explore **Terraform Release Management**, including versioning, tagging, module lifecycle, and environment promotion workflows.
