resource "azurerm_monitor_alert_prometheus_rule_group" "rule_group" {
  for_each = var.prometheus_rule_groups

  name                = each.value.name
  resource_group_name = coalesce(each.value.resource_group_name, var.resource_group_name)
  location            = coalesce(each.value.location, var.location)
  description         = each.value.description
  rule_group_enabled  = each.value.rule_group_enabled
  interval            = each.value.interval
  cluster_name        = each.value.cluster_name
  scopes              = distinct(concat([azurerm_monitor_workspace.workspace.id], coalesce(each.value.scopes, [])))

  dynamic "rule" {
    for_each = each.value.rules
    content {
      enabled     = try(rule.value.enabled, true)
      expression  = rule.value.expression
      record      = try(rule.value.record, null)
      alert       = try(rule.value.alert, null)
      severity    = try(rule.value.severity, null)
      for         = try(rule.value.for, null)
      labels      = try(rule.value.labels, {})
      annotations = try(rule.value.annotations, {})

      dynamic "action" {
        for_each = try(rule.value.actions, [])
        content {
          action_group_id   = action.value.action_group_id
          action_properties = try(action.value.action_properties, {})
        }
      }
    }
  }

  tags = merge(var.tags, try(each.value.tags, {}))
}
