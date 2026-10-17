resource "azurerm_container_app_environment" "env" {
  count = var.create_environment ? 1 : 0

  name                           = var.environment_name
  location                       = var.location
  resource_group_name            = var.resource_group_name
  log_analytics_workspace_id     = var.log_analytics_workspace_id
  infrastructure_subnet_id       = var.infrastructure_subnet_id
  internal_load_balancer_enabled = var.internal_load_balancer_enabled
  zone_redundancy_enabled        = var.zone_redundancy_enabled
  tags                           = var.tags
}

locals {
  environment_id = var.create_environment ? azurerm_container_app_environment.env[0].id : var.environment_id
}

resource "azurerm_container_app" "apps" {
  for_each = var.container_apps

  name                         = each.key
  container_app_environment_id = local.environment_id
  resource_group_name          = var.resource_group_name
  revision_mode                = each.value.revision_mode
  tags                         = merge(var.tags, try(each.value.tags, {}))

  dynamic "identity" {
    for_each = each.value.identity_type != null ? [1] : []
    content {
      type         = each.value.identity_type
      identity_ids = contains(["UserAssigned", "SystemAssigned, UserAssigned"], each.value.identity_type) ? each.value.identity_ids : null
    }
  }

  dynamic "secret" {
    for_each = each.value.secrets
    content {
      name  = secret.value.name
      value = secret.value.value
    }
  }

  dynamic "registry" {
    for_each = each.value.registries
    content {
      server               = registry.value.server
      username             = registry.value.username
      password_secret_name = registry.value.password_secret_name
      identity             = registry.value.identity
    }
  }

  dynamic "ingress" {
    for_each = each.value.ingress != null ? [each.value.ingress] : []
    content {
      external_enabled           = ingress.value.external_enabled
      target_port                = ingress.value.target_port
      transport                  = ingress.value.transport
      allow_insecure_connections = ingress.value.allow_insecure_connections

      dynamic "traffic_weight" {
        for_each = ingress.value.traffic_weight
        content {
          label           = traffic_weight.value.label
          latest_revision = traffic_weight.value.latest_revision
          revision_suffix = traffic_weight.value.revision_suffix
          percentage      = traffic_weight.value.percentage
        }
      }
    }
  }

  template {
    min_replicas = each.value.template.min_replicas
    max_replicas = each.value.template.max_replicas

    dynamic "container" {
      for_each = each.value.template.containers
      content {
        name   = container.value.name
        image  = container.value.image
        cpu    = container.value.cpu
        memory = container.value.memory

        dynamic "env" {
          for_each = container.value.env
          content {
            name        = env.value.name
            value       = env.value.value
            secret_name = env.value.secret_name
          }
        }
      }
    }
  }
}
