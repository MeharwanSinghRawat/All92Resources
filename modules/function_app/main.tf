resource "azurerm_service_plan" "asp" {
  count               = var.service_plan_id == null ? 1 : 0
  name                = coalesce(var.service_plan_name, "${var.name}-asp")
  resource_group_name = var.resource_group_name
  location            = var.location
  os_type             = "Linux"
  sku_name            = var.sku_name
  tags                = var.tags
}

resource "azurerm_linux_function_app" "function_app" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  service_plan_id     = var.service_plan_id != null ? var.service_plan_id : azurerm_service_plan.asp[0].id

  storage_account_name          = var.storage_account_name
  storage_account_access_key    = var.storage_uses_managed_identity ? null : var.storage_account_access_key
  storage_uses_managed_identity = var.storage_uses_managed_identity ? true : null

  functions_extension_version   = var.functions_extension_version
  https_only                    = var.https_only
  public_network_access_enabled = var.public_network_access_enabled
  virtual_network_subnet_id     = var.virtual_network_subnet_id

  app_settings = var.app_settings

  site_config {
    always_on                              = var.sku_name == "Y1" ? false : true
    vnet_route_all_enabled                 = var.vnet_route_all_enabled
    application_insights_connection_string = var.application_insights_connection_string
    application_insights_key               = var.application_insights_key

    application_stack {
      dotnet_version              = var.application_stack.dotnet_version
      java_version                = var.application_stack.java_version
      node_version                = var.application_stack.node_version
      powershell_core_version     = var.application_stack.powershell_core_version
      python_version              = var.application_stack.python_version
      use_custom_runtime          = var.application_stack.use_custom_runtime
      use_dotnet_isolated_runtime = var.application_stack.use_dotnet_isolated_runtime
    }
  }

  dynamic "identity" {
    for_each = var.identity_type != null ? [1] : []
    content {
      type         = var.identity_type
      identity_ids = var.identity_type == "UserAssigned" || var.identity_type == "SystemAssigned, UserAssigned" ? var.user_assigned_identity_ids : null
    }
  }

  tags = var.tags
}
