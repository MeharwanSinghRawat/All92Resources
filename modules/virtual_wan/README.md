# Azure Virtual WAN Module

Production-grade Terraform module for managing Azure Virtual WAN (vWAN), multi-region Virtual Hubs, custom routing, and spoke VNet Virtual Hub Connections.

## Features

- **Global Transit Architecture**: Interconnects global regions through Microsoft's global backbone.
- **Multi-Region Virtual Hubs**: Provisions regional hubs with automated address prefix reservation via `for_each`.
- **Hub Virtual Network Connections**: Securely connects spoke VNets to hubs with optional Internet security inspection and custom routing table associations.
- **Branch-to-Branch**: High-throughput branch-to-branch transit across VPN, ExpressRoute, and SD-WAN.

## Usage

```hcl
module "vwan" {
  source = "../../modules/virtual_wan"

  name                = "vwan-global-enterprise"
  resource_group_name = "rg-shared-transit"
  location            = "centralindia"
  type                = "Standard"

  virtual_hubs = {
    "vhub-india" = {
      location       = "centralindia"
      address_prefix = "10.100.0.0/23"
    }
  }

  hub_connections = {
    "conn-spoke-workloads" = {
      virtual_hub_name          = "vhub-india"
      remote_virtual_network_id = module.vnet.id
      internet_security_enabled = true
    }
  }

  tags = {
    Environment = "Production"
  }
}
```
