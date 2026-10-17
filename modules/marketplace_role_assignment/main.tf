resource "azurerm_marketplace_role_assignment" "assignment" {
  name                                   = var.name
  principal_id                           = var.principal_id
  role_definition_name                   = var.role_definition_name
  role_definition_id                     = var.role_definition_id
  description                            = var.description
  condition                              = var.condition
  condition_version                      = var.condition_version
  delegated_managed_identity_resource_id = var.delegated_managed_identity_resource_id
  skip_service_principal_aad_check       = var.skip_service_principal_aad_check
}
