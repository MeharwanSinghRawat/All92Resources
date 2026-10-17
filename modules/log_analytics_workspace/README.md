# Azure Log Analytics Workspace Module

This child module creates and manages an `azurerm_log_analytics_workspace` resource.

## Features
- Standard SKU support (PerGB2018, CapacityReservation, etc.).
- Configurable data retention and daily ingestion quota.
- Internet ingestion and query controls.
- Integrates with Azure Monitor diagnostic settings, Microsoft Sentinel, and Defender for Cloud.

## Usage Example

```hcl
module "log_analytics" {
  source = "../../modules/log_analytics_workspace"

  name                = "law-enterprise-dev-eastus2"
  resource_group_name = "rg-enterprise-dev-mgmt"
  location            = "eastus2"
  sku                 = "PerGB2018"
  retention_in_days   = 30

  tags = {
    Environment = "dev"
    Role        = "CentralLogging"
  }
}
```
