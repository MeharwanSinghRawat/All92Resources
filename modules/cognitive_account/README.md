# Azure AI Services / Azure OpenAI Module

Production-grade Terraform module for managing Azure AI Services (Cognitive Services) and Azure OpenAI Accounts, including private network access, custom subdomains, managed identities, and model deployments.

## Features

- **Multi-Service AI Kinds**: Supports `OpenAI`, `CognitiveServices`, `ComputerVision`, `SpeechServices`, and `TextAnalytics`.
- **Model Deployments**: Provisions LLMs and embedding models (e.g. `gpt-4o`, `text-embedding-3-small`) via `for_each`.
- **Private Subdomain**: Configures custom subdomains required for Azure Entra ID token authentication and Private Endpoints.
- **Network Isolation**: IP Whitelisting, Subnet Service Endpoints, and toggleable public access.

## Usage

```hcl
module "openai" {
  source = "../../modules/cognitive_account"

  name                  = "oai-shared-enterprise"
  resource_group_name   = "rg-shared-ai"
  location              = "eastus2"
  kind                  = "OpenAI"
  sku_name              = "S0"
  custom_subdomain_name = "oai-shared-enterprise"

  deployments = {
    "gpt-4o" = {
      model_name    = "gpt-4o"
      model_version = "2024-05-13"
      scale_type    = "Standard"
      capacity      = 20
    }
    "text-embedding" = {
      model_name    = "text-embedding-3-small"
      model_version = "1"
      scale_type    = "Standard"
      capacity      = 50
    }
  }

  tags = {
    Environment = "Production"
  }
}
```
