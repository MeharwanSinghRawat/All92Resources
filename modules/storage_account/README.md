# Azure Storage Account Terraform Child Module

A production-grade, generic Terraform child module to provision Azure Storage Accounts (`azurerm_storage_account`), Blob Containers (`azurerm_storage_container`), and File Shares (`azurerm_storage_share`).

---

## Features

- **Enterprise Security**: Enforces TLS 1.2+, HTTPS-only traffic, configurable public access, and nested item permissions.
- **Data Protection**: Configurable blob versioning and soft delete retention policies for blobs and containers.
- **Firewall & Virtual Network Rules**: Dynamic network rule sets supporting IP whitelists, Subnet IDs, and Azure service bypass.
- **Containers & File Shares**: Built-in declarative sub-resources managed through maps using semantic keys.
- **Data Lake Gen2 Support**: Hierarchical Namespace (`is_hns_enabled`) support for analytics workloads.

---

## Usage Example

```hcl
module "storage_account" {
  source = "../../modules/storage_account"

  name                     = "stenterprisedevdata01"
  resource_group_name      = "rg-enterprise-dev-data-eastus2"
  location                 = "eastus2"
  account_tier             = "Standard"
  account_replication_type = "GRS"

  blob_versioning_enabled        = true
  blob_delete_retention_days     = 14
  container_delete_retention_days = 14

  network_rules = {
    default_action             = "Deny"
    ip_rules                   = ["203.0.113.10"]
    virtual_network_subnet_ids = [module.virtual_network["spoke"].subnet_ids["data"]]
    bypass                     = ["AzureServices"]
  }

  containers = {
    raw_data = {
      container_access_type = "private"
    }
    processed_data = {
      container_access_type = "private"
    }
  }

  file_shares = {
    app_share = {
      quota = 100
    }
  }

  tags = {
    Environment = "dev"
    Tier        = "Data"
    ManagedBy   = "Terraform"
  }
}
```

---

## Inputs

| Name | Type | Description | Required | Default |
| :--- | :--- | :--- | :---: | :--- |
| `name` | `string` | Globally unique storage account name (3-24 alphanumeric lowercase). | Yes | - |
| `resource_group_name` | `string` | Parent Resource Group name. | Yes | - |
| `location` | `string` | Azure region. | Yes | - |
| `account_tier` | `string` | Storage tier (`Standard` or `Premium`). | No | `"Standard"` |
| `account_replication_type` | `string` | Replication strategy (`LRS`, `GRS`, `RAGRS`, `ZRS`, `GZRS`, `RAGZRS`). | No | `"LRS"` |
| `account_kind` | `string` | Kind of account (`StorageV2`, `BlobStorage`, etc.). | No | `"StorageV2"` |
| `min_tls_version` | `string` | Minimum TLS version. | No | `"TLS1_2"` |
| `public_network_access_enabled` | `bool` | Whether public network access is enabled. | No | `true` |
| `allow_nested_items_to_be_public` | `bool` | Allow nested items to opt into public access. | No | `false` |
| `shared_access_key_enabled` | `bool` | Permit authorization with access keys. | No | `true` |
| `is_hns_enabled` | `bool` | Enable Hierarchical Namespace (ADLS Gen2). | No | `false` |
| `blob_versioning_enabled` | `bool` | Enable blob versioning. | No | `false` |
| `blob_delete_retention_days` | `number` | Retention days for deleted blobs. | No | `7` |
| `container_delete_retention_days` | `number` | Retention days for deleted containers. | No | `7` |
| `network_rules` | `object` | Network rules restriction configuration. | No | `null` |
| `containers` | `map(object)` | Blob containers to create. | No | `{}` |
| `file_shares` | `map(object)` | File shares to create. | No | `{}` |
| `tags` | `map(string)` | Resource tags. | No | `{}` |

---

## Outputs

| Name | Description | Sensitive |
| :--- | :--- | :---: |
| `id` | Azure Resource ID of the Storage Account. | No |
| `name` | Name of the Storage Account. | No |
| `resource_group_name` | Name of the Resource Group. | No |
| `location` | Azure region of the Storage Account. | No |
| `primary_blob_endpoint` | Endpoint URL for Blob storage. | No |
| `primary_access_key` | Primary access key for the Storage Account. | Yes |
| `secondary_access_key` | Secondary access key for the Storage Account. | Yes |
| `primary_connection_string` | Connection string for Blob storage. | Yes |
| `container_ids` | Map of container keys to their resource IDs. | No |
| `file_share_ids` | Map of file share keys to their resource IDs. | No |
