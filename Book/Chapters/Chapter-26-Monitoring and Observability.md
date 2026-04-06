# Chapter 26  
## Monitoring and Observability

Infrastructure without monitoring is a black box. Terraform can deploy world‑class infrastructure, but without observability, you cannot understand its health, performance, or security posture. Monitoring and observability ensure that your systems are visible, measurable, and diagnosable — and Terraform can automate all of it.

This chapter explores how to use Terraform to deploy logging, metrics, diagnostics, alerts, dashboards, and monitoring integrations across Azure, AWS, and GCP.

---

## 26.1 Why Monitoring and Observability Matter

Monitoring provides:

- **Visibility** — understand what is happening  
- **Alerting** — detect failures early  
- **Diagnostics** — troubleshoot issues quickly  
- **Security** — detect threats and anomalies  
- **Compliance** — meet audit requirements  
- **Optimization** — improve performance and cost  

Observability extends monitoring by enabling:

- Distributed tracing  
- Log correlation  
- Dependency mapping  
- Root cause analysis  

Terraform can automate all of these capabilities.

---

## 26.2 Observability Components

A complete observability stack includes:

### 26.2.1 Logs  
- Activity logs  
- Resource logs  
- Application logs  
- Network flow logs  

### 26.2.2 Metrics  
- CPU, memory, disk  
- Network throughput  
- Database performance  
- Application metrics  

### 26.2.3 Traces  
- Distributed tracing  
- Request correlation  
- Latency analysis  

### 26.2.4 Alerts  
- Threshold-based  
- Anomaly detection  
- Log-based alerts  

### 26.2.5 Dashboards  
- Operational dashboards  
- SRE dashboards  
- Executive dashboards  

---

## 26.3 Azure Monitoring with Terraform

Azure provides a rich observability ecosystem:

- Log Analytics Workspace  
- Application Insights  
- Azure Monitor Metrics  
- Diagnostic Settings  
- Alerts  
- Dashboards  

Terraform can deploy and configure all of these.

---

## 26.4 Log Analytics Workspace

### 26.4.1 Creating a Workspace

```hcl
resource "azurerm_log_analytics_workspace" "law" {
  name                = "law-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}
```

### 26.4.2 Best Practices

- Use one workspace per environment  
- Enable 30–90 day retention  
- Use customer-managed keys if required  

---

## 26.5 Application Insights

### 26.5.1 Creating Application Insights

```hcl
resource "azurerm_application_insights" "appinsights" {
  name                = "appi-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  application_type    = "web"
}
```

### 26.5.2 Use Cases

- Web applications  
- APIs  
- Serverless functions  
- Microservices  

---

## 26.6 Diagnostic Settings

Diagnostic settings send logs and metrics to:

- Log Analytics  
- Storage accounts  
- Event Hubs  

### 26.6.1 Example Diagnostic Settings

```hcl
resource "azurerm_monitor_diagnostic_setting" "diag" {
  name                       = "diag"
  target_resource_id         = azurerm_storage_account.sa.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.law.id

  log {
    category = "StorageRead"
    enabled  = true
  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}
```

### 26.6.2 Best Practices

- Enable diagnostics for **every resource**  
- Use modules to enforce consistency  
- Include all relevant log categories  

---

## 26.7 Azure Alerts

### 26.7.1 Metric Alerts

```hcl
resource "azurerm_monitor_metric_alert" "cpu_alert" {
  name                = "cpu-alert"
  resource_group_name = var.resource_group_name
  scopes              = [azurerm_linux_virtual_machine.vm.id]
  description         = "CPU usage alert"

  criteria {
    metric_name = "Percentage CPU"
    operator    = "GreaterThan"
    threshold   = 80
    aggregation = "Average"
  }
}
```

### 26.7.2 Log Alerts

```hcl
resource "azurerm_monitor_scheduled_query_rules_alert" "log_alert" {
  name                = "error-alert"
  resource_group_name = var.resource_group_name
  location            = var.location

  action {
    action_group = [azurerm_monitor_action_group.ops.id]
  }

  query = <<QUERY
AppTraces
| where SeverityLevel >= 3
QUERY
}
```

---

## 26.8 AWS Monitoring with Terraform

AWS provides:

- CloudWatch Logs  
- CloudWatch Metrics  
- CloudWatch Alarms  
- X-Ray Tracing  
- CloudTrail  

### 26.8.1 CloudWatch Log Group

```hcl
resource "aws_cloudwatch_log_group" "app" {
  name              = "/aws/app/${var.environment}"
  retention_in_days = 30
}
```

### 26.8.2 CloudWatch Alarm

```hcl
resource "aws_cloudwatch_metric_alarm" "cpu" {
  alarm_name          = "cpu-high"
  comparison_operator = "GreaterThanThreshold"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  threshold           = 80
}
```

---

## 26.9 GCP Monitoring with Terraform

GCP provides:

- Cloud Logging  
- Cloud Monitoring  
- Cloud Trace  
- Cloud Profiler  

### 26.9.1 Log Sink

```hcl
resource "google_logging_project_sink" "sink" {
  name        = "log-sink"
  destination = google_storage_bucket.logs.url
}
```

---

## 26.10 Distributed Tracing

Terraform can deploy:

- Application Insights tracing  
- AWS X-Ray  
- GCP Cloud Trace  

Tracing provides:

- Request correlation  
- Latency analysis  
- Dependency mapping  

---

## 26.11 Dashboards

Terraform can deploy dashboards for:

- Azure Monitor  
- CloudWatch  
- GCP Monitoring  

### 26.11.1 Azure Dashboard Example

```hcl
resource "azurerm_portal_dashboard" "dashboard" {
  name                = "ops-dashboard"
  resource_group_name = var.resource_group_name
  location            = var.location

  dashboard_properties = file("dashboard.json")
}
```

---

## 26.12 Monitoring Modules

Modules should enforce:

- Diagnostic settings  
- Log Analytics workspace IDs  
- Alerts  
- Metrics  
- Dashboards  

A monitoring module ensures consistency across environments.

---

## 26.13 Observability Anti‑Patterns

### 26.13.1 No Diagnostic Settings  
No logs = no visibility.

### 26.13.2 No Alerts  
Incidents go unnoticed.

### 26.13.3 No Dashboards  
Teams cannot monitor health.

### 26.13.4 No Tracing  
Impossible to debug distributed systems.

### 26.13.5 No Retention Policies  
Storage costs explode.

---

## 26.14 Best Practices Summary

### Logging  
- Enable diagnostics for all resources  
- Use Log Analytics / CloudWatch / Cloud Logging  

### Metrics  
- Monitor CPU, memory, disk, network  
- Use metric alerts  

### Tracing  
- Use Application Insights, X-Ray, or Cloud Trace  

### Dashboards  
- Deploy dashboards for visibility  

### Governance  
- Enforce monitoring via modules  
- Enforce via Policy as Code  

---

## 26.15 Summary

Monitoring and observability are essential for reliable, secure, and scalable infrastructure.  
Key takeaways:

- Logs, metrics, traces, alerts, and dashboards form the observability stack  
- Terraform can automate all monitoring components  
- Diagnostic settings must be enabled for every resource  
- Alerts ensure issues are detected early  
- Dashboards provide visibility  
- Tracing enables deep debugging  
- Modules enforce consistency across environments  

In the next chapter, we will explore **Terraform Documentation and Knowledge Sharing**, including README standards, module documentation, architecture diagrams, and onboarding guides.
