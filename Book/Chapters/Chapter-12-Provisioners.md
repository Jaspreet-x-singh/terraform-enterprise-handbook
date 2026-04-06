# Chapter 12  
## Provisioners (and Why to Avoid Them)

Provisioners are one of the most controversial features in Terraform. They allow you to execute scripts or commands on resources after they are created, typically via SSH or WinRM. While provisioners may seem convenient, they introduce fragility, unpredictability, and operational risk into Terraform workflows.

This chapter explains what provisioners are, how they work, when they are appropriate, and why they should generally be avoided in production environments.

---

## 12.1 What Are Provisioners?

Provisioners allow Terraform to run commands on a resource after it is created.

Terraform supports:

- `local-exec` — runs a command on the machine running Terraform  
- `remote-exec` — runs a command on a remote machine via SSH or WinRM  

Example:

```hcl
resource "null_resource" "example" {
  provisioner "local-exec" {
    command = "echo Hello World"
  }
}
```

Provisioners are often used for:

- Bootstrapping servers  
- Running configuration scripts  
- Installing software  
- Executing commands after resource creation  

---

## 12.2 Types of Provisioners

### 12.2.1 Local Exec

Runs commands on the local machine.

```hcl
provisioner "local-exec" {
  command = "echo ${self.id} >> ids.txt"
}
```

Use cases:

- Triggering external systems  
- Running local scripts  
- Debugging  

---

### 12.2.2 Remote Exec

Runs commands on a remote machine via SSH or WinRM.

```hcl
provisioner "remote-exec" {
  inline = [
    "sudo apt-get update",
    "sudo apt-get install nginx -y"
  ]
}
```

Requires:

- SSH keys  
- Network access  
- Firewall rules  
- VM readiness  

This makes it fragile.

---

### 12.2.3 File Provisioner

Transfers files to a remote machine.

```hcl
provisioner "file" {
  source      = "script.sh"
  destination = "/tmp/script.sh"
}
```

Again, requires SSH connectivity.

---

## 12.3 Why Provisioners Are Discouraged

Provisioners are considered a **last resort** in Terraform.  
HashiCorp explicitly recommends avoiding them.

### 12.3.1 They Break Declarative Infrastructure

Terraform is declarative:

> “Describe the desired state.”

Provisioners are imperative:

> “Run these commands in this order.”

This breaks Terraform’s model.

---

### 12.3.2 They Are Not Idempotent

Running the same provisioner twice may:

- Install software twice  
- Modify files twice  
- Break the system  

Terraform cannot track provisioner state.

---

### 12.3.3 They Are Fragile

Provisioners depend on:

- SSH availability  
- Network connectivity  
- VM readiness  
- Firewall rules  
- OS boot timing  

If any of these fail, Terraform fails.

---

### 12.3.4 They Cause Partial Failures

If a provisioner fails:

- Terraform marks the resource as “tainted”  
- The next apply will destroy and recreate it  
- This can cause outages  

---

### 12.3.5 They Don’t Work Well in CI/CD

CI/CD pipelines often:

- Run behind firewalls  
- Have no SSH access  
- Have no inbound connectivity  
- Use ephemeral runners  

Provisioners fail in these environments.

---

## 12.4 Recommended Alternatives to Provisioners

### 12.4.1 Cloud-Init (Linux)

Use cloud-init for VM bootstrapping.

Example:

```hcl
custom_data = filebase64("${path.module}/cloud-init.yaml")
```

Cloud-init is:

- Declarative  
- Idempotent  
- Built into most Linux distros  

---

### 12.4.2 VM Extensions (Azure)

Azure provides extensions for:

- Custom scripts  
- Diagnostics  
- Monitoring  
- Desired State Configuration (DSC)  

Example:

```hcl
resource "azurerm_virtual_machine_extension" "custom" {
  name                 = "customScript"
  virtual_machine_id   = azurerm_linux_virtual_machine.vm.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.1"

  settings = <<SETTINGS
{
  "commandToExecute": "echo Hello World"
}
SETTINGS
}
```

---

### 12.4.3 AWS User Data

AWS EC2 supports user data scripts:

```hcl
user_data = file("bootstrap.sh")
```

Runs on first boot.

---

### 12.4.4 Configuration Management Tools

Use tools designed for configuration:

- Ansible  
- Chef  
- Puppet  
- SaltStack  

These tools are:

- Idempotent  
- Declarative  
- Purpose-built  

---

### 12.4.5 Containerization

Instead of configuring VMs:

- Use Docker  
- Use Kubernetes  
- Use PaaS services  

This eliminates the need for provisioners entirely.

---

## 12.5 When Provisioners *Are* Acceptable

Provisioners should be used only when:

- No other option exists  
- The action is non-critical  
- The action is idempotent  
- The action does not modify infrastructure state  

Examples:

- Triggering a webhook  
- Writing a file locally  
- Running a one-time command  

---

## 12.6 Best Practices When Using Provisioners

If you must use provisioners:

### 12.6.1 Use `on_failure = continue`

```hcl
provisioner "remote-exec" {
  on_failure = continue
}
```

Prevents tainting.

---

### 12.6.2 Use Null Resources

Avoid attaching provisioners to real resources.

```hcl
resource "null_resource" "bootstrap" {
  provisioner "local-exec" {
    command = "echo Bootstrapping"
  }
}
```

---

### 12.6.3 Use Timeouts and Retries

```hcl
connection {
  timeout = "5m"
}
```

---

### 12.6.4 Avoid Remote Exec for VM Bootstrapping

Use cloud-init or extensions instead.

---

## 12.7 Summary

Provisioners are powerful but dangerous.  
Key takeaways:

- Provisioners break Terraform’s declarative model  
- They are not idempotent  
- They are fragile and error-prone  
- They cause tainted resources and partial failures  
- They should be avoided in production  
- Use cloud-init, VM extensions, user data, or configuration management instead  

In the next chapter, we will explore **managing secrets in Terraform**, including Key Vault, AWS Secrets Manager, GCP Secret Manager, and secure CI/CD patterns.
