# Azure Application Gateway Child Module

This production-grade Terraform module provisions and manages an **Azure Application Gateway (Standard_v2 / WAF_v2)** with support for autoscale, multiple frontend ports, backend pools, HTTP settings, listeners, probes, and SSL certificates.

---

## Features

- **v2 SKU & Autoscale Support**: Configured for `Standard_v2` and `WAF_v2` with dynamic autoscaling (`min_capacity`, `max_capacity`).
- **Flexible Frontend & Routing**: Multi-port listeners, path-based or basic routing rules, and custom health probes.
- **Dedicated Public IP**: Built-in creation of Standard SKU Static Public IP or integration with an external Public IP.
- **Strict Validations**: Input constraints ensure standard-compliant names and SKUs.
- **Comprehensive Outputs**: Exports Gateway IDs, Public IP addresses, backend pool IDs, and listener IDs.

---

## Usage Example

```hcl
module "application_gateway" {
  source = "../../modules/application_gateway"

  name                = "agw-enterprise-dev-eastus2"
  resource_group_name = "rg-enterprise-dev-network-eastus2"
  location            = "eastus2"
  subnet_id           = module.virtual_network["hub"].subnet_ids["appgw"]

  sku = {
    name = "Standard_v2"
    tier = "Standard_v2"
  }

  autoscale_configuration = {
    min_capacity = 1
    max_capacity = 2
  }

  frontend_ports = {
    http = {
      port = 80
      name = "port_80"
    }
  }

  backend_address_pools = {
    aks_backend = {
      name         = "aks-backend-pool"
      ip_addresses = ["10.20.2.10"]
    }
  }

  backend_http_settings = {
    http = {
      name                  = "http-settings"
      port                  = 80
      protocol              = "Http"
      cookie_based_affinity = "Disabled"
    }
  }

  http_listeners = {
    http = {
      name     = "http-listener"
      protocol = "Http"
    }
  }

  request_routing_rules = {
    rule1 = {
      name                      = "http-routing-rule"
      rule_type                 = "Basic"
      http_listener_key         = "http"
      backend_address_pool_key  = "aks_backend"
      backend_http_settings_key = "http"
      priority                  = 100
    }
  }

  tags = {
    Environment = "Development"
  }
}
```
