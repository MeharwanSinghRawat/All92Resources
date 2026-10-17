# Azure PostgreSQL Flexible Server Terraform Child Module

A production-grade, enterprise-ready Terraform child module to provision Azure Database for PostgreSQL Flexible Servers (`azurerm_postgresql_flexible_server`), associated databases, firewall rules, server configurations, and active directory administrators.

---

## Architecture & Best Practices

- **Single Responsibility Principle**: Focuses purely on PostgreSQL server lifecycle and its native sub-resources (`databases`, `firewall_rules`, `configurations`). Networking DNS zones are decoupled and consumed via `private_dns_zone_id`.
- **Domain-Separated Files**:
  - `main.tf` - Core server instance & credentials
  - `databases.tf` - Database schemas
  - `firewall.tf` - IP whitelists
  - `configurations.tf` - Server parameters
  - `identity.tf` - Microsoft Entra ID integration
- **High Availability & Resiliency**: Multi-zone and same-zone HA support (`ZoneRedundant` or `SameZone`), custom maintenance window scheduling.

---

## Usage Examples

### 1. Private Access with Virtual Network Integration

```hcl
module "postgresql" {
  source = "../../modules/postgresql_flexible_server"

  name                = "psql-enterprise-dev-eastus2"
  resource_group_name = "rg-enterprise-dev-data-eastus2"
  location            = "eastus2"
  server_version      = "16"
  sku_name            = "GP_Standard_D2s_v3"
  storage_mb          = 65536

  # VNet Integration
  delegated_subnet_id = module.virtual_network["spoke"].subnet_ids["postgres"]
  private_dns_zone_id = module.private_dns_zone["postgres"].id

  administrator_login = "psqladmin"

  databases = {
    app_db = {
      name      = "appdb"
      charset   = "UTF8"
      collation = "en_US.utf8"
    }
  }

  tags = {
    Environment = "Development"
    ManagedBy   = "Terraform"
  }
}
```

### 2. Public Access with Firewall Rules

```hcl
module "postgresql_public" {
  source = "../../modules/postgresql_flexible_server"

  name                = "psql-dev-public-eastus2"
  resource_group_name = "rg-enterprise-dev-data-eastus2"
  location            = "eastus2"
  server_version      = "16"
  sku_name            = "B_Standard_B1ms"
  storage_mb          = 32768

  public_network_access_enabled = true

  firewall_rules = {
    office = {
      start_ip_address = "203.0.113.10"
      end_ip_address   = "203.0.113.10"
    }
  }

  databases = {
    devdb = {}
  }

  tags = {
    Environment = "Development"
  }
}
```
