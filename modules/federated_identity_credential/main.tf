resource "azurerm_federated_identity_credential" "credential" {
  name                = var.name
  resource_group_name = var.resource_group_name
  parent_id           = var.parent_id
  audience            = var.audience
  issuer              = var.issuer
  subject             = var.subject
}
