# Azure Monitor Diagnostic Setting Module

This child module creates and manages an `azurerm_monitor_diagnostic_setting` resource, enabling seamless logging and metrics streaming to Log Analytics Workspaces, Storage Accounts, or Event Hubs.

## Features
- Dynamic streaming of category groups (`allLogs`, `audit`) and specific log categories.
- Automatic metric category streaming (`AllMetrics`).
- Supports multiple destinations: Log Analytics, Storage Accounts, Event Hubs, and Partner Solutions.
- Supports `Dedicated` resource-specific destination table routing.

## Usage Example

```hcl
module "key_vault_diagnostics" {
  source = "../../modules/monitor_diagnostic_setting"

  name                       = "diag-kv-enterprise"
  target_resource_id         = module.key_vault.id
  log_analytics_workspace_id = module.log_analytics_workspace.id

  enabled_log_category_groups = ["allLogs"]
  metric_categories           = ["AllMetrics"]
}
```
