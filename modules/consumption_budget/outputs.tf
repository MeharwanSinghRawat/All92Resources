output "id" {
  description = "The ID of the Consumption Budget."
  value = (
    var.scope_type == "subscription" ?
    azurerm_consumption_budget_subscription.sub_budget[0].id :
    azurerm_consumption_budget_resource_group.rg_budget[0].id
  )
}

output "name" {
  description = "The Name of the Consumption Budget."
  value = (
    var.scope_type == "subscription" ?
    azurerm_consumption_budget_subscription.sub_budget[0].name :
    azurerm_consumption_budget_resource_group.rg_budget[0].name
  )
}
