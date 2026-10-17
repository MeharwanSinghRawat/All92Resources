# Azure Route Table Module

This child module creates an `azurerm_route_table` with optional custom routes (`azurerm_route`) and subnet route table associations (`azurerm_subnet_route_table_association`).

## Features
- Manages Azure Route Table with BGP route propagation control.
- Supports flexible custom route definitions (VirtualAppliance, Internet, VnetLocal, None, VirtualNetworkGateway).
- Automatic subnet associations.

## Usage Example

```hcl
module "spoke_udr" {
  source = "../../modules/route_table"

  name                = "rt-enterprise-dev-spoke"
  resource_group_name = "rg-enterprise-dev-network"
  location            = "eastus2"

  routes = {
    default_egress = {
      address_prefix         = "0.0.0.0/0"
      next_hop_type          = "VirtualAppliance"
      next_hop_in_ip_address = "10.10.1.4" # Azure Firewall Private IP
    }
  }

  subnet_ids = {
    app = "/subscriptions/.../subnets/snet-app"
  }

  tags = {
    Environment = "dev"
    Role        = "SpokeRouting"
  }
}
```
