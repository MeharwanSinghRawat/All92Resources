# Azure Load Balancer Terraform Module

Enterprise-grade Terraform child module for deploying and managing **Azure Load Balancers (`azurerm_lb`)**, supporting both **Public** and **Internal (Private)** configurations.

## Features

- **Public & Internal Modes**: Support for public frontends (integrating with standalone `modules/public_ip`) and private frontends (subnet-attached).
- **Decoupled Architecture**: Seamlessly references Public IP IDs managed by `modules/public_ip` without resource coupling.
- **Backend Pools & Health Probes**: Complete support for Backend Address Pools (`azurerm_lb_backend_address_pool`) and HTTP/HTTPS/TCP Health Probes (`azurerm_lb_probe`).
- **Load Balancing Rules**: Flexible rules (`azurerm_lb_rule`) for port mapping, floating IP, TCP reset, and custom distribution.
- **Inbound NAT Rules**: Configurable port-forwarding rules (`azurerm_lb_nat_rule`) for SSH, RDP, and administrative access.
- **Availability Zones**: Multi-zone support for high availability.

## Usage Example

### 1. Internal Load Balancer

```hcl
module "internal_lb" {
  source = "../../modules/load_balancer"

  name                = "lb-enterprise-dev-internal-eastus2"
  resource_group_name = "rg-enterprise-dev-network-eastus2"
  location            = "eastus2"
  sku                 = "Standard"

  frontend_ip_configurations = {
    internal = {
      name               = "internal-frontend"
      subnet_id          = module.virtual_network["hub"].subnet_ids["management"]
      private_ip_address = "10.10.2.10"
    }
  }

  backend_address_pools = {
    app_backend = {
      name = "app-backend-pool"
    }
  }

  probes = {
    tcp_health = {
      protocol = "Tcp"
      port     = 8080
    }
  }

  load_balancing_rules = {
    app_traffic = {
      frontend_ip_configuration_name = "internal-frontend"
      backend_address_pool_name      = "app_backend"
      probe_name                     = "tcp_health"
      protocol                       = "Tcp"
      frontend_port                  = 8080
      backend_port                   = 8080
    }
  }

  tags = {
    Environment = "Development"
  }
}
```

### 2. Public Load Balancer

```hcl
module "public_lb" {
  source = "../../modules/load_balancer"

  name                = "lb-enterprise-dev-public-eastus2"
  resource_group_name = "rg-enterprise-dev-network-eastus2"
  location            = "eastus2"
  sku                 = "Standard"

  frontend_ip_configurations = {
    public = {
      name                 = "public-frontend"
      public_ip_address_id = module.public_ip["lb"].id
    }
  }

  tags = {
    Environment = "Development"
  }
}
```
