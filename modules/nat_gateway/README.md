# Azure NAT Gateway Module

This child module creates and manages an `azurerm_nat_gateway` with public IP associations and subnet associations.

## Features
- Provides secure, scalable outbound Internet access for subnets.
- Configurable idle timeout (4 to 120 minutes).
- Supports Availability Zones.
- Flexible association with Public IPs, Public IP prefixes, and subnets.

## Usage Example

```hcl
module "nat_gateway" {
  source = "../../modules/nat_gateway"

  name                = "nat-enterprise-dev-eastus2"
  resource_group_name = "rg-enterprise-dev-network"
  location            = "eastus2"

  public_ip_address_ids = [module.public_ip["nat"].id]
  
  subnet_ids = {
    app = module.virtual_network["spoke"].subnet_ids["app"]
  }

  tags = {
    Environment = "dev"
    Role        = "OutboundEgress"
  }
}
```
