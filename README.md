# Enterprise Azure Terraform Infrastructure Framework

This repository provides production-grade, generic Terraform **child modules** and **parent environment modules** for Azure infrastructure deployments.

---

## Directory Architecture

```text
Terraform/
├── modules/                         # Reusable, generic child modules
│   ├── resource_group/              # Azure Resource Group child module
│   │   ├── main.tf                  # Resource implementation & dynamic blocks
│   │   ├── variables.tf             # Inputs with strict types & validations
│   │   ├── outputs.tf               # Resource attributes & IDs exported
│   │   ├── versions.tf              # Provider & Terraform constraints
│   │   └── README.md                # Module documentation & examples
│   ├── virtual_network/             # Azure Virtual Network & Subnets child module
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   ├── versions.tf
│   │   └── README.md
│   ├── network_security_group/      # Azure NSG & Security Rules child module
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   ├── versions.tf
│   │   └── README.md
│   ├── storage_account/             # Azure Storage Account child module
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   ├── versions.tf
│   │   └── README.md
│   ├── key_vault/                   # Azure Key Vault child module
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   ├── versions.tf
│   │   └── README.md
│   ├── private_endpoint/            # Azure Private Endpoint child module
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   ├── versions.tf
│   │   └── README.md
│   ├── aks/                         # Azure Kubernetes Service child module
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   ├── versions.tf
│   │   └── README.md
│   ├── container_registry/          # Azure Container Registry child module
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   ├── versions.tf
│   │   └── README.md
│   ├── virtual_machine/             # Azure Virtual Machine (Linux/Windows) child module
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   ├── versions.tf
│   │   └── README.md
│   ├── application_gateway/         # Azure Application Gateway (v2) child module
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   ├── versions.tf
│   │   └── README.md
│   └── azure_firewall/              # Azure Firewall & Policy child module
│       ├── main.tf
│       ├── variables.tf
│       ├── outputs.tf
│       ├── versions.tf
│       └── README.md
│
├── azure-pipelines.yml              # Enterprise Multi-Stage Azure DevOps CI/CD Pipeline
├── .gitignore                       # Production Git rules for Terraform & Azure DevOps
└── environments/                    # Parent / Root modules (Composition layer)
    └── dev/                         # Development environment
        ├── main.tf                  # Calls child modules with environment values
        ├── variables.tf             # Environment inputs
        ├── terraform.tfvars         # Active production environment variable values
        ├── terraform.tfvars.example # Full template with demo values & inline instructions
        ├── outputs.tf               # Environment-level outputs
        ├── providers.tf             # Provider configurations
        └── versions.tf              # Backend & provider requirements
```

---

## Complete Module Registry (52 Modules)

A comprehensive catalog detailing all 52 enterprise child modules, architectural descriptions, input/output contracts, and standard structures is available in:
👉 **[Module Catalog Documentation (modules/README.md)](modules/README.md)**

---

## Configuration & Usage Guide (`terraform.tfvars.example`)

A complete reference configuration file is provided at:
👉 **[`environments/dev/terraform.tfvars.example`](environments/dev/terraform.tfvars.example)**

### How to use:
1. **Copy the template**:
   ```bash
   cp environments/dev/terraform.tfvars.example environments/dev/terraform.tfvars
   ```
2. **Decoupled Key Referencing**:
   Resources reference each other using logical map keys rather than hardcoded Azure Resource IDs (e.g., `resource_group_key = "app"`, `vnet_key = "spoke"`, `subnet_key = "data"`, `identity_key = "app_workload"`).
3. **Enable/Disable Services**:
   Set unused modules to an empty map (e.g., `azure_firewalls = {}`) to skip them cleanly.

---

## Azure DevOps (ADO) CI/CD Pipeline Suite

This repository includes an enterprise-grade modular CI/CD architecture located in the [`pipelines/`](pipelines/) directory:

👉 **[Complete Pipeline Guide & Documentation (pipelines/README.md)](pipelines/README.md)**

### Pipeline Structure:
- [`pipelines/ci-pipeline.yml`](pipelines/ci-pipeline.yml): Dedicated CI for PRs (DevSecOps scans + Plan + Infracost, **Apply blocked**).
- [`pipelines/cd-pipeline.yml`](pipelines/cd-pipeline.yml): Dedicated CD with runtime **Environment Selection Dropdown** (`dev`, `qa`, `prod`).
- [`pipelines/azure-pipelines.yml`](pipelines/azure-pipelines.yml) (and root [`azure-pipelines.yml`](azure-pipelines.yml)): Unified orchestrator.
- [`pipelines/templates/`](pipelines/templates/): Reusable templates across multiple repositories:
  - [`steps-install-tools.yml`](pipelines/templates/steps-install-tools.yml): Installs TF + TFLint + Trivy + Checkov + Gitleaks + Infracost.
  - [`stage-security-lint.yml`](pipelines/templates/stage-security-lint.yml): Code quality & DevSecOps SAST gate.
  - [`stage-terraform-plan.yml`](pipelines/templates/stage-terraform-plan.yml): Plan generation, cost report, and reviewer notification.
  - [`stage-terraform-apply.yml`](pipelines/templates/stage-terraform-apply.yml): Manual validation gate via ADO Environments & Apply.

### 5 Free Integrated Tools:
1. **Gitleaks** (Secret leakage scanner)
2. **TFLint** (Terraform deep linter)
3. **Checkov** (CIS & security policy compliance)
4. **Trivy** (IaC misconfiguration scanner)
5. **Infracost** (Monthly cloud cost diff on PRs)


