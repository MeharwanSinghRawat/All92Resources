# Azure Cosmos DB Account Module

Production-grade Terraform module for managing Azure Cosmos DB multi-model database accounts (SQL / NoSQL API, MongoDB API), multi-region replication, consistency levels, SQL databases, and autoscale containers.

## Features

- **Multi-Model APIs**: Supports `GlobalDocumentDB` (Core SQL), `MongoDB`, and `Parse`.
- **Multi-Region & HA**: Automatic failover, multi-region replication, and zone-redundant replicas.
- **Consistency Policies**: Supports `Session`, `BoundedStaleness`, `Strong`, `ConsistentPrefix`, and `Eventual`.
- **Databases & Containers**: Full support for SQL databases and containers with provisioned throughput or Autoscale RU/s.

## Usage

```hcl
module "cosmosdb" {
  source = "../../modules/cosmosdb_account"

  name                = "cosmos-shared-workloads"
  resource_group_name = "rg-shared-data"
  location            = "centralindia"
  kind                = "GlobalDocumentDB"

  consistency_policy = {
    consistency_level = "Session"
  }

  sql_databases = {
    "appdb" = {
      max_throughput = 1000 # Autoscale (100 - 1000 RU/s)
    }
  }

  sql_containers = {
    "users" = {
      database_name       = "appdb"
      partition_key_paths = ["/userId"]
    }
  }

  tags = {
    Environment = "Production"
  }
}
```
