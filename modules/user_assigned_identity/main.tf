resource "azurerm_user_assigned_identity" "identity" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags
}

resource "azurerm_federated_identity_credential" "federated" {
  for_each = var.federated_identity_credentials

  name                = coalesce(each.value.name, each.key)
  resource_group_name = var.resource_group_name
  parent_id           = azurerm_user_assigned_identity.identity.id
  audience            = each.value.audience
  issuer              = each.value.issuer
  subject             = each.value.subject
}
