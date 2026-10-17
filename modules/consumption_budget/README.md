# Azure Consumption Budget Module

This child module manages Azure Cost Management Budgets at either Subscription or Resource Group level via `azurerm_consumption_budget_subscription` or `azurerm_consumption_budget_resource_group`.

## Features
- Track cloud spend and set financial guardrails for Landing Zones.
- Configurable notification thresholds (e.g. 50%, 80%, 100%, 120% forecast).
- Alerts sent to email lists, Action Groups, and Azure RBAC roles (Owner/Contributor).

## Usage Example

```hcl
module "dev_budget" {
  source = "../../modules/consumption_budget"

  name            = "budget-enterprise-dev"
  scope_type      = "subscription"
  subscription_id = "/subscriptions/00000000-0000-0000-0000-000000000000"
  amount          = 1000
  time_grain      = "Monthly"

  time_period = {
    start_date = "2026-01-01T00:00:00Z"
  }

  notifications = {
    warn_80 = {
      operator       = "GreaterThan"
      threshold      = 80
      threshold_type = "Actual"
      contact_emails = ["finops@company.com"]
    }
    forecast_100 = {
      operator       = "GreaterThanOrEqualTo"
      threshold      = 100
      threshold_type = "Forecasted"
      contact_emails = ["lead-devops@company.com"]
    }
  }
}
```
