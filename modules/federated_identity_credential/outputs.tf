output "id" {
  description = "The ID of the Federated Identity Credential."
  value       = azurerm_federated_identity_credential.credential.id
}

output "name" {
  description = "The Name of the Federated Identity Credential."
  value       = azurerm_federated_identity_credential.credential.name
}

output "issuer" {
  description = "The Issuer URL configured for this Federated Identity Credential."
  value       = azurerm_federated_identity_credential.credential.issuer
}

output "subject" {
  description = "The Subject identifier configured for this Federated Identity Credential."
  value       = azurerm_federated_identity_credential.credential.subject
}
