resource "azurerm_key_vault" "vault" {
  name                            = var.name
  resource_group_name             = var.resource_group_name
  location                        = var.location
  sku_name                        = var.sku_name
  tenant_id                       = var.tenant_id
  enabled_for_deployment          = var.enabled_for_deployment
  enabled_for_disk_encryption     = var.enabled_for_disk_encryption
  enabled_for_template_deployment = var.enabled_for_template_deployment
  rbac_authorization_enabled      = var.enable_rbac_authorization
  purge_protection_enabled        = var.purge_protection_enabled
  soft_delete_retention_days      = var.soft_delete_retention_days
  public_network_access_enabled   = var.public_network_access_enabled

  dynamic "network_acls" {
    for_each = var.network_acls != null ? [var.network_acls] : []
    content {
      bypass                     = try(network_acls.value.bypass, "AzureServices")
      default_action             = network_acls.value.default_action
      ip_rules                   = try(network_acls.value.ip_rules, [])
      virtual_network_subnet_ids = try(network_acls.value.virtual_network_subnet_ids, [])
    }
  }

  tags = var.tags
}

resource "azurerm_key_vault_access_policy" "policies" {
  for_each = var.access_policies

  key_vault_id            = azurerm_key_vault.vault.id
  tenant_id               = coalesce(each.value.tenant_id, var.tenant_id)
  object_id               = each.value.object_id
  application_id          = each.value.application_id
  certificate_permissions = try(each.value.certificate_permissions, [])
  key_permissions         = try(each.value.key_permissions, [])
  secret_permissions      = try(each.value.secret_permissions, [])
  storage_permissions     = try(each.value.storage_permissions, [])
}

resource "azurerm_role_assignment" "roles" {
  for_each = var.role_assignments

  scope                = azurerm_key_vault.vault.id
  role_definition_name = each.value.role_definition_name
  role_definition_id   = each.value.role_definition_id
  principal_id         = each.value.principal_id
  description          = each.value.description
}

resource "azurerm_key_vault_secret" "secrets" {
  for_each = var.secrets

  name            = coalesce(each.value.name, each.key)
  value           = each.value.value
  key_vault_id    = azurerm_key_vault.vault.id
  content_type    = each.value.content_type
  not_before_date = each.value.not_before_date
  expiration_date = each.value.expiration_date
  tags            = merge(var.tags, try(each.value.tags, {}))

  depends_on = [
    azurerm_key_vault_access_policy.policies,
    azurerm_role_assignment.roles
  ]
}

resource "azurerm_key_vault_key" "keys" {
  for_each = var.keys

  name         = coalesce(each.value.name, each.key)
  key_vault_id = azurerm_key_vault.vault.id
  key_type     = try(each.value.key_type, "RSA")
  key_size     = try(each.value.key_size, 2048)
  key_opts     = try(each.value.key_opts, ["decrypt", "encrypt", "sign", "unwrapKey", "verify", "wrapKey"])
  tags         = merge(var.tags, try(each.value.tags, {}))

  depends_on = [
    azurerm_key_vault_access_policy.policies,
    azurerm_role_assignment.roles
  ]
}
