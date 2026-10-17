# Azure Bastion Host Terraform Child Module

A production-grade, enterprise-ready Terraform child module to provision Azure Bastion Hosts (`azurerm_bastion_host`) and associated Standard Public IPs (`azurerm_public_ip`).

---

## Features

- **Enterprise SKUs & Capabilities**: Supports Basic, Standard, and Premium tiers with native client tunneling, file copy, IP connect, shareable links, and autoscaling (2-50 scale units).
- **Flexible Public IP Management**: Automatically provisions a dedicated Static Standard Public IP, or attaches an existing Public IP ID.
- **Availability Zones**: Zone-redundant deployment support.
- **Decoupled Architecture**: Consumes standard `AzureBastionSubnet` ID without tight coupling.

---

## Usage Example

```hcl
module "bastion" {
  source = "../../modules/bastion_host"

  name                = "bas-enterprise-dev-eastus2"
  resource_group_name = "rg-enterprise-dev-network-eastus2"
  location            = "eastus2"
  sku                 = "Standard"
  scale_units         = 2

  subnet_id = module.virtual_network["hub"].subnet_ids["bastion"]

  tunneling_enabled  = true
  ip_connect_enabled = true
  file_copy_enabled  = true

  tags = {
    Environment = "Development"
    Tier        = "Management"
  }
}
```
