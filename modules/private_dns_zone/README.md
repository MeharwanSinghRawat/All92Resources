# Azure Private DNS Zone Terraform Child Module

A production-grade, generic Terraform child module to provision Azure Private DNS Zones (`azurerm_private_dns_zone`) and Virtual Network Links (`azurerm_private_dns_zone_virtual_network_link`).

---

## Features

- **Centralized DNS Governance**: Reusable for any private endpoint or PaaS private integration (PostgreSQL, MySQL, Storage, Key Vault, Container Registry, etc.).
- **Multi-VNet Resolution**: Dynamically link multiple Virtual Networks (Hub, Spokes) with optional auto-registration.
- **Enterprise Tagging**: Consistent tag propagation across zones and links.

---

## Usage Example

```hcl
module "postgres_dns" {
  source = "../../modules/private_dns_zone"

  name                = "privatelink.postgres.database.azure.com"
  resource_group_name = "rg-enterprise-dev-network-eastus2"

  virtual_network_links = {
    spoke = {
      virtual_network_id   = module.virtual_network["spoke"].id
      registration_enabled = false
    }
  }

  tags = {
    Environment = "Development"
    Tier        = "Networking"
  }
}
```
