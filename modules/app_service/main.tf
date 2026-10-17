# ==============================================================================
# Internal Service Plan (Commented Out)
# ==============================================================================
# NOTE: Service Plan management has been decoupled into the dedicated child
# module 'modules/service_plan'. The App Service module receives 'service_plan_id'.
# Kept here as commented reference in case standalone creation is needed:
# ==============================================================================
# resource "azurerm_service_plan" "asp" {
#   name                   = coalesce(var.service_plan_name, "${var.name}-asp")
#   resource_group_name    = var.resource_group_name
#   location               = var.location
#   os_type                = var.os_type
#   sku_name               = var.sku_name
#   worker_count           = var.worker_count
#   zone_balancing_enabled = var.zone_balancing_enabled
#   tags                   = var.tags
# }

resource "azurerm_linux_web_app" "linux" {
  count                         = var.os_type == "Linux" ? 1 : 0
  name                          = var.name
  resource_group_name           = var.resource_group_name
  location                      = var.location
  service_plan_id               = var.service_plan_id
  https_only                    = var.https_only
  public_network_access_enabled = var.public_network_access_enabled
  virtual_network_subnet_id     = var.virtual_network_subnet_id

  dynamic "identity" {
    for_each = var.identity_type != null ? [1] : []
    content {
      type         = var.identity_type
      identity_ids = contains(["UserAssigned", "SystemAssigned, UserAssigned"], var.identity_type) ? var.user_assigned_identity_ids : null
    }
  }

  app_settings = var.app_settings

  dynamic "connection_string" {
    for_each = var.connection_strings
    content {
      name  = connection_string.key
      type  = connection_string.value.type
      value = connection_string.value.value
    }
  }

  site_config {
    always_on              = var.sku_name == "F1" ? false : try(var.site_config.always_on, false)
    vnet_route_all_enabled = var.vnet_route_all_enabled
    http2_enabled          = try(var.site_config.http2_enabled, true)
    minimum_tls_version    = try(var.site_config.minimum_tls_version, "1.2")
    ftps_state             = try(var.site_config.ftps_state, "Disabled")
    health_check_path      = try(var.site_config.health_check_path, null)

    application_stack {
      dotnet_version           = try(var.application_stack.dotnet_version, null)
      java_version             = try(var.application_stack.java_version, null)
      node_version             = try(var.application_stack.node_version, null)
      php_version              = try(var.application_stack.php_version, null)
      python_version           = try(var.application_stack.python_version, null)
      ruby_version             = try(var.application_stack.ruby_version, null)
      docker_image_name        = try(var.application_stack.docker_image_name, null)
      docker_registry_url      = try(var.application_stack.docker_registry_url, null)
      docker_registry_username = try(var.application_stack.docker_registry_username, null)
      docker_registry_password = try(var.application_stack.docker_registry_password, null)
    }

    dynamic "cors" {
      for_each = var.site_config != null && try(var.site_config.cors, null) != null ? [var.site_config.cors] : []
      content {
        allowed_origins     = cors.value.allowed_origins
        support_credentials = try(cors.value.support_credentials, false)
      }
    }
  }

  tags = var.tags
}

resource "azurerm_windows_web_app" "windows" {
  count                         = var.os_type == "Windows" ? 1 : 0
  name                          = var.name
  resource_group_name           = var.resource_group_name
  location                      = var.location
  service_plan_id               = var.service_plan_id
  https_only                    = var.https_only
  public_network_access_enabled = var.public_network_access_enabled
  virtual_network_subnet_id     = var.virtual_network_subnet_id

  dynamic "identity" {
    for_each = var.identity_type != null ? [1] : []
    content {
      type         = var.identity_type
      identity_ids = contains(["UserAssigned", "SystemAssigned, UserAssigned"], var.identity_type) ? var.user_assigned_identity_ids : null
    }
  }

  app_settings = var.app_settings

  dynamic "connection_string" {
    for_each = var.connection_strings
    content {
      name  = connection_string.key
      type  = connection_string.value.type
      value = connection_string.value.value
    }
  }

  site_config {
    always_on              = var.sku_name == "F1" ? false : try(var.site_config.always_on, false)
    vnet_route_all_enabled = var.vnet_route_all_enabled
    http2_enabled          = try(var.site_config.http2_enabled, true)
    minimum_tls_version    = try(var.site_config.minimum_tls_version, "1.2")
    ftps_state             = try(var.site_config.ftps_state, "Disabled")
    health_check_path      = try(var.site_config.health_check_path, null)

    application_stack {
      current_stack  = try(var.application_stack.current_stack, null)
      dotnet_version = try(var.application_stack.dotnet_version, null)
      java_version   = try(var.application_stack.java_version, null)
      node_version   = try(var.application_stack.node_version, null)
      php_version    = try(var.application_stack.php_version, null)
    }

    dynamic "cors" {
      for_each = var.site_config != null && try(var.site_config.cors, null) != null ? [var.site_config.cors] : []
      content {
        allowed_origins     = cors.value.allowed_origins
        support_credentials = try(cors.value.support_credentials, false)
      }
    }
  }

  tags = var.tags
}
