# ==============================================================================
# Internal Public IP (Commented Out)
# ==============================================================================
# NOTE: Public IP management has been decoupled into the dedicated child module
# 'modules/public_ip'. Virtual Machine can receive public IP if enabled.
# Kept here as commented reference in case standalone/internal creation is needed:
# ==============================================================================

# resource "azurerm_public_ip" "pip" {
#   count               = var.enable_public_ip ? 1 : 0
#   name                = coalesce(var.public_ip_name, "${var.name}-pip")
#   resource_group_name = var.resource_group_name
#   location            = var.location
#   allocation_method   = var.public_ip_allocation_method
#   sku                 = var.public_ip_sku
#   tags                = var.tags
# }
