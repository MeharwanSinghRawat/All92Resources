resource "azurerm_resource_group" "rg" {
  name     = var.name
  location = var.location
  tags     = var.tags
}

resource "azurerm_management_lock" "rg_lock" {
  for_each   = var.lock_level != null ? { "this" = var.lock_level } : {}
  name       = "${var.name}-lock"
  scope      = azurerm_resource_group.rg.id
  lock_level = each.value
  notes      = var.lock_notes
}

resource "azurerm_role_assignment" "rg_roles" {
  for_each             = var.role_assignments
  scope                = azurerm_resource_group.rg.id
  role_definition_name = each.value.role_definition_name
  role_definition_id   = each.value.role_definition_id
  principal_id         = each.value.principal_id
  condition            = each.value.condition
  condition_version    = each.value.condition_version
  description          = each.value.description
}
