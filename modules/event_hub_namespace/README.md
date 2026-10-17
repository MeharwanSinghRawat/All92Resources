# Azure Event Hub Namespace Module

Production-grade Terraform module for provisioning Azure Event Hub Namespaces, individual Event Hub topics, consumer groups, capture descriptions, and authorization policies.

## Features

- **Namespace Tiers**: Supports `Basic`, `Standard`, and `Premium` with Auto-Inflate and Zone Redundancy.
- **Topics & Partitioning**: Configures event hubs with customizable partition counts and retention policies.
- **Blob Archiving / Capture**: Supports automated data capture to Azure Blob Storage / Data Lake.
- **Consumer Groups**: Configures independent consumer groups for streaming subscribers.
- **Network Isolation**: IP filtering and VNet service endpoint integration.

## Usage

```hcl
module "eventhub" {
  source = "../../modules/event_hub_namespace"

  name                = "evh-shared-streaming"
  resource_group_name = "rg-shared-data"
  location            = "centralindia"
  sku                 = "Standard"
  capacity            = 1

  eventhubs = {
    "telemetry-stream" = {
      partition_count   = 4
      message_retention = 7
    }
  }

  consumer_groups = {
    "analytics-consumer" = {
      eventhub_name = "telemetry-stream"
    }
  }

  tags = {
    Environment = "Production"
  }
}
```
