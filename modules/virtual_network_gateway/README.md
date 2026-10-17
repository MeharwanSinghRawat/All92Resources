# Azure Virtual Network Gateway Module

Production-grade Terraform module for managing Azure Virtual Network Gateways (VPN & ExpressRoute), Local Network Gateways, and Site-to-Site / VNet-to-VNet IPsec VPN Connections.

## Features

- **Gateway Types**: Supports `Vpn` (Route-Based / Policy-Based) and `ExpressRoute`.
- **High Availability**: Active-Active dual IP configurations and Zone-Redundant SKUs (`VpnGw1AZ`, `ErGw1AZ`).
- **Dynamic BGP Routing**: Dynamic BGP peering with on-premises routers.
- **Site-to-Site Connections**: Manages Local Network Gateways and IPsec/IKE policy-driven connections via `for_each`.
- **Point-to-Site (P2S)**: Optional client VPN configuration for remote workers.

## Usage

```hcl
module "vpn_gateway" {
  source = "../../modules/virtual_network_gateway"

  name                 = "vpngw-hub-centralindia"
  resource_group_name  = "rg-hub-networking"
  location             = "centralindia"
  type                 = "Vpn"
  vpn_type             = "RouteBased"
  sku                  = "VpnGw1"
  subnet_id            = module.vnet.subnets["GatewaySubnet"].id
  public_ip_address_id = module.public_ip_gw.id

  local_network_gateways = {
    "onprem-datacenter" = {
      gateway_address = "203.0.113.1"
      address_spaces  = ["192.168.0.0/16"]
    }
  }

  connections = {
    "s2s-to-onprem" = {
      type                       = "IPsec"
      local_network_gateway_name = "onprem-datacenter"
      shared_key                 = "YourComplexSharedSecretKey123!"
    }
  }

  tags = {
    Environment = "Production"
  }
}
```
