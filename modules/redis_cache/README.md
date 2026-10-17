# Azure Cache for Redis Module

Production-grade Terraform module for provisioning and configuring Azure Cache for Redis with clustering, managed identities, patch schedules, and IP firewall rules.

## Features

- **SKU Tiers**: Supports `Basic`, `Standard` (HA with replica), and `Premium` (clustering, VNet injection, persistence).
- **Security**: TLS 1.2 enforcement, disabled non-SSL port by default, Managed Identity support.
- **Maintenance Windows**: Dynamic patch schedule configuration for maintenance controls.
- **Firewall Rules**: Optional client IP whitelist rules via `for_each`.

## Usage

```hcl
module "redis" {
  source = "../../modules/redis_cache"

  name                = "redis-shared-app"
  resource_group_name = "rg-shared-data"
  location            = "centralindia"
  sku_name            = "Standard"
  family              = "C"
  capacity            = 1

  minimum_tls_version = "1.2"
  enable_non_ssl_port = false

  tags = {
    Environment = "Production"
  }
}
```
