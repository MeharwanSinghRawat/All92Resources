# Azure Front Door (Standard / Premium) Module

Production-grade Terraform module for managing Azure Front Door profiles, endpoints, origin groups, origins (with optional Private Link), and caching/routing rules.

## Features

- **Profile Tiers**: `Standard_AzureFrontDoor` and `Premium_AzureFrontDoor` (with Managed WAF and Private Link).
- **Global Anycast Routing**: High availability multi-origin load balancing with configurable health probes.
- **Private Link Origins**: Secure backend connectivity directly to Azure App Service, Storage, or Internal Load Balancers without public internet exposure.
- **Edge Caching**: Edge compression, query string caching behaviors, and HTTPS redirection.

## Usage

```hcl
module "frontdoor" {
  source = "../../modules/front_door"

  name                = "afd-global-portal"
  resource_group_name = "rg-shared-networking"
  sku_name            = "Standard_AzureFrontDoor"

  endpoints = {
    "web-portal" = {}
  }

  origin_groups = {
    "app-backends" = {
      health_probe = {
        path     = "/healthz"
        protocol = "Https"
      }
    }
  }

  origins = {
    "primary-app" = {
      origin_group_name  = "app-backends"
      host_name          = "app-primary.azurewebsites.net"
      origin_host_header = "app-primary.azurewebsites.net"
    }
  }

  routes = {
    "default-route" = {
      endpoint_name     = "web-portal"
      origin_group_name = "app-backends"
      patterns_to_match = ["/*"]
    }
  }

  tags = {
    Environment = "Production"
  }
}
```
