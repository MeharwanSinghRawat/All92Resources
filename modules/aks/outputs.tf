output "id" {
  description = "The ID of the Managed Kubernetes Cluster."
  value       = azurerm_kubernetes_cluster.aks.id
}

output "name" {
  description = "The Name of the Managed Kubernetes Cluster."
  value       = azurerm_kubernetes_cluster.aks.name
}

output "fqdn" {
  description = "The FQDN of the Azure Kubernetes Managed Cluster."
  value       = azurerm_kubernetes_cluster.aks.fqdn
}

output "oidc_issuer_url" {
  description = "The OIDC issuer URL that is associated with the cluster."
  value       = azurerm_kubernetes_cluster.aks.oidc_issuer_url
}

output "kube_config_raw" {
  description = "Raw Kubernetes config to be used by kubectl and other compatible tools."
  value       = azurerm_kubernetes_cluster.aks.kube_config_raw
  sensitive   = true
}

output "kube_admin_config_raw" {
  description = "Raw Kubernetes admin config to be used by kubectl and other compatible tools."
  value       = azurerm_kubernetes_cluster.aks.kube_admin_config_raw
  sensitive   = true
}

output "identity_principal_id" {
  description = "The Principal ID of the SystemAssigned identity assigned to the Managed Kubernetes Cluster."
  value       = try(azurerm_kubernetes_cluster.aks.identity[0].principal_id, null)
}

output "kubelet_identity_object_id" {
  description = "The Object ID of the user-assigned identity used by the Kubelet."
  value       = try(azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id, null)
}

output "node_resource_group" {
  description = "The auto-generated Resource Group where the Kubernetes Nodes reside."
  value       = azurerm_kubernetes_cluster.aks.node_resource_group
}

output "node_pool_ids" {
  description = "Map of additional node pool keys to their resource IDs."
  value       = { for k, v in azurerm_kubernetes_cluster_node_pool.node_pools : k => v.id }
}
