resource "azurerm_policy_definition" "policy" {
  name                = var.name
  policy_type         = var.policy_type
  mode                = var.mode
  display_name        = var.display_name
  description         = var.description
  management_group_id = var.management_group_id
  policy_rule         = var.policy_rule
  metadata            = var.metadata
  parameters          = var.parameters
}
