# Chapter 9  
## Understanding the Terraform Workflow

Terraform’s workflow is one of its greatest strengths. It provides a predictable, safe, and structured process for provisioning and managing infrastructure. Whether you’re deploying a single resource or orchestrating a multi‑cloud enterprise platform, the Terraform workflow remains consistent.

This chapter breaks down the workflow in detail, explains what happens behind the scenes, and teaches you how to use each phase effectively.

---

## 9.1 The Terraform Workflow at a Glance

Terraform follows a simple but powerful lifecycle:

1. **Write** — Define infrastructure in `.tf` files  
2. **Init** — Initialize providers and modules  
3. **Plan** — Preview changes  
4. **Apply** — Execute changes  
5. **Destroy** — Remove infrastructure  
6. **Refresh** — Sync state with real infrastructure  
7. **Validate & Format** — Ensure correctness and consistency  

This workflow is consistent across:

- Local development  
- CI/CD pipelines  
- Terraform Cloud  
- Multi‑module architectures  

---

## 9.2 Step 1 — Write Configuration

You begin by writing HCL configuration files:

- `main.tf` — resources and modules  
- `variables.tf` — inputs  
- `outputs.tf` — outputs  
- `providers.tf` — provider configuration  
- `locals.tf` — computed values  

Terraform loads all `.tf` files in the directory automatically.

### 9.2.1 Best Practices When Writing Code

- Use consistent naming  
- Use modules for reusable logic  
- Avoid hardcoding values  
- Use variables and locals  
- Use `terraform fmt` to format code  
- Use `terraform validate` to check syntax  

---

## 9.3 Step 2 — Initialize with `terraform init`

`terraform init` prepares the working directory.

It:

- Downloads providers  
- Installs modules  
- Configures the backend  
- Prepares the dependency graph  

Example:

```bash
terraform init
```

### 9.3.1 When to Re‑Run Init

- After adding a new provider  
- After changing provider versions  
- After adding a module  
- After modifying backend configuration  

---

## 9.4 Step 3 — Preview Changes with `terraform plan`

`terraform plan` compares:

- Desired state (configuration)  
- Actual state (state file)  
- Real infrastructure (via provider refresh)  

It then generates a plan showing:

- Resources to be created  
- Resources to be updated  
- Resources to be destroyed  

Example:

```bash
terraform plan
```

### 9.4.1 Understanding Plan Output

Symbols:

- `+` create  
- `~` update  
- `-` delete  
- `-/+` replace  

Example:

```
# azurerm_storage_account.sa will be created
+ name = "stapp001"
```

### 9.4.2 Why Plan Is Critical

- Prevents accidental destruction  
- Shows drift  
- Enables code review  
- Supports CI/CD workflows  

---

## 9.5 Step 4 — Apply Changes with `terraform apply`

`terraform apply` executes the plan.

Example:

```bash
terraform apply
```

Terraform will:

- Ask for confirmation  
- Execute operations in dependency order  
- Create/update/delete resources  
- Update the state file  

### 9.5.1 Auto‑Approve Mode

Used in CI/CD:

```bash
terraform apply -auto-approve
```

Never use this manually in production.

---

## 9.6 Step 5 — Destroy Infrastructure with `terraform destroy`

`terraform destroy` removes all resources in the configuration.

Example:

```bash
terraform destroy
```

Terraform will:

- Show what will be deleted  
- Ask for confirmation  
- Remove resources  
- Update state  

### 9.6.1 When to Use Destroy

- Temporary environments  
- Testing  
- Cleanup  
- Sandbox deployments  

Never run destroy in production without strict approvals.

---

## 9.7 Step 6 — Refreshing State

Terraform automatically refreshes state during:

- `plan`  
- `apply`  
- `destroy`  

You can also refresh manually:

```bash
terraform refresh
```

### 9.7.1 Why Refresh Matters

- Detects drift  
- Updates attributes  
- Ensures accurate plans  

---

## 9.8 Step 7 — Validate and Format

### 9.8.1 Validate

```bash
terraform validate
```

Checks:

- Syntax  
- Types  
- Structure  
- Provider configuration  

### 9.8.2 Format

```bash
terraform fmt
```

Ensures consistent formatting.

---

## 9.9 The Full Workflow in Practice

A typical workflow:

```bash
terraform fmt
terraform validate
terraform init
terraform plan
terraform apply
```

In CI/CD:

- `fmt`  
- `validate`  
- `tflint`  
- `plan`  
- Manual approval  
- `apply`  

---

## 9.10 Behind the Scenes: What Terraform Actually Does

### 9.10.1 During Init

- Downloads providers  
- Installs modules  
- Configures backend  

### 9.10.2 During Plan

- Refreshes state  
- Builds dependency graph  
- Compares desired vs actual state  
- Generates execution plan  

### 9.10.3 During Apply

- Executes operations in dependency order  
- Handles retries  
- Updates state  

---

## 9.11 Common Workflow Mistakes

### 9.11.1 Forgetting to Run Init  
Terraform will fail to find providers.

### 9.11.2 Ignoring Plan Output  
This can lead to accidental destruction.

### 9.11.3 Running Apply Without Reviewing Changes  
Always review plans.

### 9.11.4 Editing State Files Manually  
Never do this.

### 9.11.5 Using Workspaces Incorrectly  
Workspaces are not for production environments.

---

## 9.12 Summary

The Terraform workflow is simple, predictable, and powerful.  
Key takeaways:

- Write → Init → Plan → Apply → Destroy  
- Plan is your safety net  
- Apply executes changes in dependency order  
- State is updated after every operation  
- Validate and format ensure quality  
- CI/CD pipelines automate the workflow  

In the next chapter, we will explore **Terraform’s dependency graph**, a critical concept for understanding how Terraform orchestrates infrastructure changes.
