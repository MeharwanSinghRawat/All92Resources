resource "azurerm_monitor_metric_alert" "alert" {
  name                     = var.name
  resource_group_name      = var.resource_group_name
  scopes                   = var.scopes
  description              = var.description
  severity                 = var.severity
  frequency                = var.frequency
  window_size              = var.window_size
  enabled                  = var.enabled
  auto_mitigate            = var.auto_mitigate
  target_resource_type     = var.target_resource_type
  target_resource_location = var.target_resource_location
  tags                     = var.tags

  dynamic "criteria" {
    for_each = var.criteria
    content {
      metric_namespace       = criteria.value.metric_namespace
      metric_name            = criteria.value.metric_name
      aggregation            = criteria.value.aggregation
      operator               = criteria.value.operator
      threshold              = criteria.value.threshold
      skip_metric_validation = criteria.value.skip_metric_validation

      dynamic "dimension" {
        for_each = criteria.value.dimensions
        content {
          name     = dimension.value.name
          operator = dimension.value.operator
          values   = dimension.value.values
        }
      }
    }
  }

  dynamic "dynamic_criteria" {
    for_each = var.dynamic_criteria != null ? [var.dynamic_criteria] : []
    content {
      metric_namespace         = dynamic_criteria.value.metric_namespace
      metric_name              = dynamic_criteria.value.metric_name
      aggregation              = dynamic_criteria.value.aggregation
      operator                 = dynamic_criteria.value.operator
      alert_sensitivity        = dynamic_criteria.value.alert_sensitivity
      evaluation_total_count   = dynamic_criteria.value.evaluation_total_count
      evaluation_failure_count = dynamic_criteria.value.evaluation_failure_count
      ignore_data_before       = dynamic_criteria.value.ignore_data_before
      skip_metric_validation   = dynamic_criteria.value.skip_metric_validation

      dynamic "dimension" {
        for_each = dynamic_criteria.value.dimensions
        content {
          name     = dimension.value.name
          operator = dimension.value.operator
          values   = dimension.value.values
        }
      }
    }
  }

  dynamic "action" {
    for_each = var.action_group_ids
    content {
      action_group_id    = action.value
      webhook_properties = length(var.webhook_properties) > 0 ? var.webhook_properties : null
    }
  }
}
