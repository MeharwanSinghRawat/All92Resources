# Azure Management Group Module

This child module creates and manages an `azurerm_management_group` resource in the Azure Resource Hierarchy.

## Features
- Builds CAF (Cloud Adoption Framework) management hierarchies: Platform, Landing Zones, Sandbox, Decommissioned.
- Supports parent management group association.
- Supports subscription allocation to management groups.

## Usage Example

```hcl
module "mg_landing_zones" {
  source = "../../modules/management_group"

  name         = "mg-landing-zones"
  display_name = "Landing Zones"

  subscription_ids = [
    "00000000-0000-0000-0000-000000000000"
  ]
}
```
