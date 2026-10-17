output "id" {
  description = "The ID of the Policy Assignment."
  value = (
    var.scope_type == "subscription" ?
    azurerm_subscription_policy_assignment.sub_assignment[0].id :
    azurerm_resource_group_policy_assignment.rg_assignment[0].id
  )
}

output "name" {
  description = "The Name of the Policy Assignment."
  value = (
    var.scope_type == "subscription" ?
    azurerm_subscription_policy_assignment.sub_assignment[0].name :
    azurerm_resource_group_policy_assignment.rg_assignment[0].name
  )
}

output "principal_id" {
  description = "The Principal ID of the Policy Assignment's Managed Identity (if enabled)."
  value = (
    var.scope_type == "subscription" ?
    try(azurerm_subscription_policy_assignment.sub_assignment[0].identity[0].principal_id, null) :
    try(azurerm_resource_group_policy_assignment.rg_assignment[0].identity[0].principal_id, null)
  )
}
