# Azure App Service Terraform Module

Enterprise-grade Terraform module to provision **Azure App Service (Linux / Windows Web Apps)** and **Azure App Service Plans** using modern AzureRM v3/v4 provider resources (`azurerm_linux_web_app`, `azurerm_windows_web_app`, and `azurerm_service_plan`).

## Features

- **Modern Architecture**: Implements modern, non-deprecated resources replacing legacy `azurerm_app_service`.
- **Operating Systems**: Supports both Linux (`azurerm_linux_web_app`) and Windows (`azurerm_windows_web_app`).
- **Flexible Service Plan**: Automatically creates a dedicated App Service Plan or connects to an existing one via `service_plan_id`.
- **Virtual Network Integration**: Native regional VNet integration via subnet ID.
- **Security & Identity**: Managed Identity (SystemAssigned/UserAssigned), HTTPS-only enforcement, minimum TLS 1.2, FTPS state.
- **Application Stacks**: Supports Node.js, Python, .NET, Java, PHP, Ruby, and custom Docker container images.
- **Configuration**: App settings (environment variables), connection strings, health checks, and CORS rules.

## Usage Example

```hcl
module "app_service" {
  source = "../../modules/app_service"

  name                = "app-enterprise-dev-web-001"
  resource_group_name = "rg-enterprise-dev-app-eastus2"
  location            = "eastus2"
  os_type             = "Linux"
  sku_name            = "B1"

  application_stack = {
    python_version = "3.11"
  }

  app_settings = {
    "ENVIRONMENT" = "Development"
  }

  tags = {
    Environment = "Development"
  }
}
```
