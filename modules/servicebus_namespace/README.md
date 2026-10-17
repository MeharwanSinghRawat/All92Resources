# Azure Service Bus Namespace Module

This child module creates and manages an `azurerm_servicebus_namespace` with decoupled message queues (`azurerm_servicebus_queue`) and publish-subscribe topics (`azurerm_servicebus_topic`).

## Features
- Standard and Premium Tier support with dedicated messaging units.
- Dead-letter queue support on message expiration.
- Sessions and duplicate detection support.
- Private Endpoint ready.

## Usage Example

```hcl
module "service_bus" {
  source = "../../modules/servicebus_namespace"

  name                = "sb-enterprise-dev-eastus2"
  resource_group_name = "rg-enterprise-dev-app"
  location            = "eastus2"
  sku                 = "Standard"

  queues = {
    order_processing = {
      name                                 = "q-orders"
      dead_lettering_on_message_expiration = true
    }
  }

  topics = {
    notifications = {
      name = "t-notifications"
    }
  }

  tags = {
    Environment = "dev"
    Role        = "EnterpriseMessaging"
  }
}
```
