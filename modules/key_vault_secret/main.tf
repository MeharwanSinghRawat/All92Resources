resource "azurerm_key_vault_secret" "secret" {
  for_each = var.secrets

  name            = coalesce(each.value.name, each.key)
  value           = each.value.value
  key_vault_id    = var.key_vault_id
  content_type    = each.value.content_type
  not_before_date = each.value.not_before_date
  expiration_date = each.value.expiration_date
  tags            = merge(var.tags, try(each.value.tags, {}))
}
