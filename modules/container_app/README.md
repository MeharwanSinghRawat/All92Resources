# Azure Container App Module

Production-grade Terraform module for provisioning Azure Container App Environments and Container Apps with ingress, container registries, traffic splitting, and autoscaling.

## Features

- **Managed Environment**: Provisions or attaches to existing ACA managed environments with Log Analytics integration.
- **Microservices Deployment**: Provisions multiple container apps via `for_each`.
- **Ingress & Traffic Weighting**: Configures external or internal ingress with fine-grained traffic splitting for blue/green or canary deployments.
- **Identity & Registries**: Supports System-Assigned and User-Assigned Managed Identities, alongside ACR registry bindings.

## Usage

```hcl
module "container_apps" {
  source = "../../modules/container_app"

  create_environment         = true
  environment_name           = "cae-shared-prod"
  resource_group_name        = "rg-shared-compute"
  location                   = "centralindia"
  log_analytics_workspace_id = module.log_analytics_workspace.id

  container_apps = {
    "web-api" = {
      ingress = {
        external_enabled = true
        target_port      = 80
      }
      template = {
        min_replicas = 1
        max_replicas = 5
        containers = [
          {
            name   = "api"
            image  = "mcr.microsoft.com/azuredocs/aci-helloworld:latest"
            cpu    = 0.5
            memory = "1.0Gi"
          }
        ]
      }
    }
  }

  tags = {
    Environment = "Production"
  }
}
```
