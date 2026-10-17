# 🚀 Enterprise Azure DevOps CI/CD Pipeline Suite for Terraform

Production-grade, modular, and 100% reusable Azure DevOps pipeline architecture with built-in DevSecOps guardrails, cost estimations, and multi-environment approval gates.

---

## 📁 Directory Architecture

```plaintext
pipelines/
├── README.md                      # Complete setup & operations guide
├── ci-pipeline.yml                # Dedicated CI pipeline for Pull Requests
├── cd-pipeline.yml                # Dedicated CD pipeline for deployments with environment dropdown
├── azure-pipelines.yml             # Unified orchestrator (CI + CD combined)
└── templates/                     # Reusable templates across multiple repositories
    ├── steps-install-tools.yml     # Installs Terraform + 5 Free DevSecOps tools
    ├── stage-security-lint.yml    # Quality, Linting & SAST Scanning stage
    ├── stage-terraform-plan.yml    # Plan generation, Infracost breakdown & Reviewer notice
    └── stage-terraform-apply.yml   # Manual approval-gated deployment stage
```

---

## 🛡️ Integrated Free DevSecOps & FinOps Tools

All tools used are **100% free and open-source** — no paid licenses or subscriptions required:

| Tool | Purpose | Open-Source Source |
| :--- | :--- | :--- |
| **Gitleaks** | Detects accidentally hardcoded passwords, tokens, API keys | [GitHub gitleaks](https://github.com/gitleaks/gitleaks) |
| **Terraform fmt** | Checks HCL formatting across all files recursively | Native HashiCorp CLI |
| **TFLint** | Catches syntax errors, deprecated provider arguments, naming rules | [GitHub tflint](https://github.com/terraform-linters/tflint) |
| **Checkov** | CIS benchmark compliance, security best practices & posture | [Bridgecrew Checkov](https://github.com/bridgecrewio/checkov) |
| **Trivy** | Cloud misconfiguration and IaC vulnerability scanner | [Aqua Security Trivy](https://github.com/aquasecurity/trivy) |
| **Infracost** | FinOps breakdown of monthly cloud cost changes on PRs | [Infracost Community](https://github.com/infracost/infracost) |

---

## 🔄 How Triggers & Workflows Operate

### 1. Pull Request Trigger (Feature Branch -> `main`)
- **Action:** Developer raises a Pull Request from any feature branch (e.g. `feature/network`, `feature/app`) targeting `main`.
- **Pipeline Execution:**
  1. `SecurityAndQualityAudit`: Runs selected tools (Gitleaks, TFLint, Checkov, Trivy, `terraform fmt`, `terraform validate`).
  2. `TerraformPlanAndCost`: Generates speculative plan (`tfplan`) + Infracost monthly cost diff.
  3. `Reviewer Notification`: Rich Markdown summary uploaded to PR overview tab showing all planned changes & costs.
  4. **Apply Stage is 100% BLOCKED:** `condition: and(succeeded(), ne(variables['Build.Reason'], 'PullRequest'))` enforces that the Apply stage **never** runs on a Pull Request.

### 2. Post-Merge to `main` (Apply with Manual Validation Gate)
- **Action:** Reviewer reviews the PR, approves it, and code merges into the `main` branch.
- **Pipeline Execution:**
  1. Pipeline triggers automatically on `main`.
  2. Re-runs Security & speculative Plan to verify against target state.
  3. **✋ Manual Validation Gate (`ManualValidation@0`):**
     - The pipeline **pauses** before executing `terraform apply`.
     - An interactive validation modal appears in Azure DevOps: *"Review the Terraform Plan artifact and click Resume to deploy or Reject to abort."*
     - Notification email is sent to approvers/reviewers (`notifyUsers: $(Build.RequestedForEmail)`).
  4. **🚀 Terraform Apply:**
     - Runs **ONLY** after an authorized reviewer clicks **"Resume"** (Approve).
     - Deploys infrastructure using the exact validated `tfplan` artifact.

---

## ⚙️ Azure DevOps Portal Setup Guide

### Step 1: Create Azure Service Connections
In **Project Settings** > **Service connections**, create Service Connections with Azure Resource Manager (Workload Identity or Service Principal):
- `sc-azure-terraform-dev`
- `sc-azure-terraform-qa`
- `sc-azure-terraform-prod`

### Step 2: Create ADO Environments & Approval Gates
In **Pipelines** > **Environments**, create three environments:
1. `azure-infrastructure-dev`
2. `azure-infrastructure-qa`
3. `azure-infrastructure-prod`

For each environment:
1. Click **Approvals and checks** (`...` menu).
2. Add **Approvals**.
3. Add the designated reviewers / team leads who must approve before deployment.
4. (Optional) Add **Business Hours** or **Branch control** (e.g., only allow `main` to deploy to `prod`).

### Step 3: Register Pipelines in Azure DevOps
1. Go to **Pipelines** > **New pipeline**.
2. Select **Azure Repos Git** > Select your repository.
3. Select **Existing Azure Pipelines YAML file**.
4. Path options:
   - For unified CI/CD: `/pipelines/azure-pipelines.yml` (or `/azure-pipelines.yml`)
   - For standalone CI: `/pipelines/ci-pipeline.yml`
   - For standalone CD: `/pipelines/cd-pipeline.yml`
