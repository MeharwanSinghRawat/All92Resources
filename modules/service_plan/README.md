# Azure Service Plan Terraform Module

Enterprise Terraform module for provisioning **Azure App Service Plan (`azurerm_service_plan`)** to host Web Apps and Function Apps.

## Features

- **Decoupled Architecture**: Separates the compute hosting plan from the web applications, enabling 1:many sharing and independent lifecycle management.
- **Cross-Platform**: Supports both `Linux` and `Windows` workloads.
- **Flexible Scaling**: Supports Elastic Worker counts, Zone Balancing, and Per-Site Scaling.
- **Enterprise Standards**: Input validations, resource tagging, and standard outputs.

## Usage Example

```hcl
module "service_plan" {
  source = "../../modules/service_plan"

  name                = "asp-enterprise-dev-eastus2"
  resource_group_name = "rg-enterprise-dev-app-eastus2"
  location            = "eastus2"
  os_type             = "Linux"
  sku_name            = "B1"

  tags = {
    Environment = "Development"
  }
}
```
