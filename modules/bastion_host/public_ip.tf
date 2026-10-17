# ==============================================================================
# Internal Public IP (Commented Out)
# ==============================================================================
# NOTE: Public IP management has been decoupled into the dedicated child module
# 'modules/public_ip'. The bastion module receives 'public_ip_id' via variables.
# Kept here as commented reference in case standalone/internal creation is needed:
# ==============================================================================

# resource "azurerm_public_ip" "bastion" {
#   name                = coalesce(var.public_ip_name, "${var.name}-pip")
#   resource_group_name = var.resource_group_name
#   location            = var.location
#   allocation_method   = "Static"
#   sku                 = "Standard"
#   zones               = length(var.zones) > 0 ? var.zones : null
#   tags                = var.tags
# }
