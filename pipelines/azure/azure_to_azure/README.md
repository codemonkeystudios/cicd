# Azure Repos → Azure VM (AAD SSH) — Heavily Commented

Deploy from **Azure DevOps Repos** via **Azure Pipelines** to an **Azure Linux VM**
using a **Federated (OIDC) Azure Resource Manager Service Connection** (no client
secrets). Store bundles in **Azure Blob Storage**, then use **az ssh vm** (AAD) to
run an on‑box orchestrator.

## Contents
- `azure-pipelines.yml` — Package → Upload to Blob + short‑lived SAS → AAD SSH → orchestrator.
- `scripts/az_vm_run_deploy.sh` — stop → before → rsync → after → start → validate.
- `scripts/*.sh` — lifecycle hooks.
- `app/` — placeholder payload.

## One‑time Azure DevOps setup
1. Create a Service Connection (Azure Resource Manager → **Workload Identity**).
   - Scope to your Subscription or Resource Group.
   - Name it (e.g., `azure-oidc-conn`) and grant to your Pipeline.
2. Assign the SPN roles:
   - `Storage Blob Data Contributor` on your storage account/container.
   - `Virtual Machine Administrator Login` (or VM User Login + sudo path) on the VM/RG.
   - (Optional) `Reader` on the VM resource group.
3. Ensure the VM has **AADLoginForLinux** extension.

## Configure variables
Edit `variables:` in `azure-pipelines.yml`:
- `AZURE_SERVICE_CONNECTION` — the service connection name
- `AZURE_STORAGE_ACCOUNT`, `AZURE_STORAGE_CONTAINER`, `BLOB_PREFIX`
- `AZ_RESOURCE_GROUP`, `AZ_VM_NAME`, `AZ_VM_LOCATION`, `APP_DIR`
- `SAS_EXPIRY_MINUTES`

## Flow
1. Package `scripts/ + app/` → `dist/bundle-<sha>.zip`.
2. Upload to Blob Storage; generate read‑only SAS for ~30 minutes.
3. SSH (AAD) to the VM and run `scripts/az_vm_run_deploy.sh`, which executes hooks and health check.

## Safer rollouts
- Behind a Load Balancer or Application Gateway, drain connections before restart.
- For fleets: use VM Scale Sets with rolling upgrades, or image‑based rollouts.

## Notes
- Long remote command is split and quoted to keep it readable.
- Consider replacing SAS with VM Managed Identity + `az storage blob download --auth-mode login`.
