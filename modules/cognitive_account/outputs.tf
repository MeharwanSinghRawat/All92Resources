output "id" {
  description = "The ID of the Cognitive Service Account."
  value       = azurerm_cognitive_account.account.id
}

output "name" {
  description = "The name of the Cognitive Service Account."
  value       = azurerm_cognitive_account.account.name
}

output "endpoint" {
  description = "The endpoint used to connect to the Cognitive Service Account."
  value       = azurerm_cognitive_account.account.endpoint
}

output "primary_access_key" {
  description = "A primary access key which can be used to authenticate with this Cognitive Service Account."
  value       = azurerm_cognitive_account.account.primary_access_key
  sensitive   = true
}

output "secondary_access_key" {
  description = "The secondary access key which can be used to authenticate with this Cognitive Service Account."
  value       = azurerm_cognitive_account.account.secondary_access_key
  sensitive   = true
}

output "identity_principal_id" {
  description = "The Principal ID of the System-Assigned Identity."
  value       = try(azurerm_cognitive_account.account.identity[0].principal_id, null)
}

output "deployments" {
  description = "Map of created Cognitive Model Deployments."
  value = {
    for k, v in azurerm_cognitive_deployment.deployments : k => v.id
  }
}
