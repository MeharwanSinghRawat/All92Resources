# Azure Monitor Action Group Module

Production-grade Terraform module for managing Azure Monitor Action Groups with multi-channel alerting (Email, SMS, Webhook, Logic App, Azure Functions, Azure App Push, ARM Roles, Event Hub).

## Features

- **Multi-Channel Alert Notification**: Supports Email, SMS, Webhooks (Slack/Teams/PagerDuty), ARM roles, Logic Apps, and Functions.
- **Common Alert Schema**: Default enabled for streamlined modern alert payloads across channels.
- **Webhook Authentication**: Optional Azure AD (`aad_auth`) secured endpoints.

## Usage

```hcl
module "action_group" {
  source = "../../modules/monitor_action_group"

  name                = "ag-critical-ops"
  resource_group_name = "rg-shared-monitoring"
  short_name          = "crit-ops"

  email_receivers = [
    {
      name          = "devops-leads"
      email_address = "devops-alerts@example.com"
    }
  ]

  webhook_receivers = [
    {
      name        = "slack-pagerduty"
      service_uri = "https://events.pagerduty.com/integration/xxx/enqueue"
    }
  ]

  tags = {
    Environment = "Production"
  }
}
```
