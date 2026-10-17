# Azure SQL Server & Database Module

This child module creates and manages an `azurerm_mssql_server` along with `azurerm_mssql_database` and optional firewall rules (`azurerm_mssql_firewall_rule`).

## Features
- Automated random secure password generation if none is supplied.
- Azure AD Admin integration (supports AzureAD-only authentication).
- Multiple databases with custom SKU, collation, and geo-backup settings.
- Private endpoint ready (public network access disabled by default).

## Usage Example

```hcl
module "sql_server" {
  source = "../../modules/mssql_server"

  name                          = "sql-enterprise-dev-eastus2"
  resource_group_name           = "rg-enterprise-dev-data"
  location                      = "eastus2"
  administrator_login           = "sqladmin"
  public_network_access_enabled = false

  databases = {
    appdb = {
      name     = "sqldb-app-dev"
      sku_name = "Basic"
    }
  }

  tags = {
    Environment = "dev"
    Role        = "SQLDatabase"
  }
}
```
