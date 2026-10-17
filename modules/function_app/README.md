# Azure Function App Terraform Child Module

A production-grade, enterprise-ready Terraform child module to provision Azure Linux Function Apps (`azurerm_linux_function_app`), App Service Plans (`azurerm_service_plan`), and individual serverless functions (`azurerm_function_app_function`).

---

## Features

- **Serverless or Dedicated Plans**: Automatic App Service Plan creation (Consumption `Y1`, Elastic Premium `EP1`, or dedicated plans) or connection to an existing plan.
- **Declarative Serverless Functions**: Native `azurerm_function_app_function` child resources support with binding configurations (`config_json`) and inline code files (`file`).
- **Flexible Runtime Stacks**: Pre-configured application stacks for Python, Node.js, .NET (isolated), Java, and PowerShell.
- **Enterprise Security**: HTTPS-only, TLS 1.2+, System/User Managed Identities, optional VNet outbound integration.
- **Monitoring**: Built-in Application Insights connection string integration.

---

## Usage Example

```hcl
module "function_app" {
  source = "../../modules/function_app"

  name                = "func-enterprise-dev-eastus2"
  resource_group_name = "rg-enterprise-dev-app-eastus2"
  location            = "eastus2"
  sku_name            = "Y1" # Consumption Plan

  storage_account_name       = module.storage_account["data_store"].name
  storage_account_access_key = module.storage_account["data_store"].primary_access_key

  application_stack = {
    python_version = "3.11"
  }

  app_settings = {
    "FUNCTIONS_WORKER_RUNTIME" = "python"
    "ENVIRONMENT"              = "dev"
  }

  functions = {
    health_check = {
      name     = "HealthCheck"
      language = "Python"
      config_json = jsonencode({
        bindings = [
          {
            authLevel = "anonymous"
            type      = "httpTrigger"
            direction = "in"
            name      = "req"
            methods   = ["get"]
          },
          {
            type      = "http"
            direction = "out"
            name      = "$return"
          }
        ]
      })
      files = {
        init = {
          name    = "__init__.py"
          content = <<-PYTHON
            import azure.functions as func

            def main(req: func.HttpRequest) -> func.HttpResponse:
                return func.HttpResponse("OK", status_code=200)
          PYTHON
        }
      }
    }
  }

  tags = {
    Environment = "Development"
    Role        = "Serverless"
  }
}
```
