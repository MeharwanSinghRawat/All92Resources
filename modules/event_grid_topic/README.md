# Azure Event Grid Topic Module

Production-grade Terraform module for provisioning Azure Event Grid Topics and Event Subscriptions with multi-destination dispatching (Webhooks, Azure Functions, Event Hubs, Service Bus Queues & Topics), subject filtering, and dead-letter/retry policies.

## Features

- **Standard & CloudEvent Schemas**: Supports `EventGridSchema`, `CloudEventSchemaV1_0`, and `CustomEventSchema`.
- **Multi-Target Subscriptions**: Dispatches events to Webhooks, Azure Functions, Service Bus, and Event Hubs via `for_each`.
- **Filtering & Retries**: Supports prefix/suffix subject filters, event type filtering, and custom retry intervals.
- **Security & Access**: Network IP rules and Managed Identity authentication.

## Usage

```hcl
module "eventgrid" {
  source = "../../modules/event_grid_topic"

  name                = "egt-shared-orders"
  resource_group_name = "rg-shared-events"
  location            = "centralindia"
  input_schema        = "EventGridSchema"

  subscriptions = {
    "order-processed" = {
      webhook_endpoint = {
        url = "https://api.mycompany.com/webhook/orders"
      }
      subject_filter = {
        subject_begins_with = "orders/created"
      }
    }
  }

  tags = {
    Environment = "Production"
  }
}
```
