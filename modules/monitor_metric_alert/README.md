# Azure Monitor Metric Alert Module

Production-grade Terraform module for managing Azure Monitor Metric Alerts with static thresholds or machine learning dynamic anomaly detection.

## Features

- **Static Criteria**: Multi-condition metric evaluation with dimensions.
- **Dynamic Criteria**: Automated machine learning anomaly baselines with configurable sensitivity (`Low`, `Medium`, `High`).
- **Action Group Integration**: Direct integration with notification action groups.
- **Auto Mitigation**: Automatically resolves active alert state when metrics normalize.

## Usage

```hcl
module "high_cpu_alert" {
  source = "../../modules/monitor_metric_alert"

  name                = "alert-vm-high-cpu"
  resource_group_name = "rg-shared-monitoring"
  scopes              = [module.virtual_machine.id]
  description         = "Trigger alert when VM CPU percentage exceeds 85% for 5 minutes"
  severity            = 1

  criteria = [
    {
      metric_namespace = "Microsoft.Compute/virtualMachines"
      metric_name      = "Percentage CPU"
      aggregation      = "Average"
      operator         = "GreaterThan"
      threshold        = 85
    }
  ]

  action_group_ids = [module.action_group.id]

  tags = {
    Environment = "Production"
  }
}
```
