# GitHub Actions → Azure VM (AAD SSH)

Deploy from **GitHub Actions** to an **Azure Linux VM** using **OIDC + Federated Credentials**
(no client secret), store bundles in **Azure Blob Storage**, then use **az ssh vm**
(AAD) to run an on‑box orchestrator.

## Contents
- `.github/workflows/deploy_azure.yml` - OIDC login, zip, blob upload + short‑lived SAS, AAD SSH, orchestrator.
- `scripts/az_vm_run_deploy.sh` - orchestrates stop → before → rsync → after → start → validate.
- `scripts/*.sh` - lifecycle hooks.
- `app/` - your application payload.

## One‑time Azure setup
1. **Entra ID App Registration** (client ID) with a **Federated Credential** for this GitHub repo/ref.
2. **Role assignments** to that app:
   - `Storage Blob Data Contributor` on your storage account or container.
   - `Virtual Machine Administrator Login` (or `Virtual Machine User Login` + sudo mechanism) on the VM/RG.
   - (Optional) `Reader` on the VM resource group.
3. **VM**: Enable **AADLoginForLinux** extension (for AAD SSH). Ensure outbound internet.
4. **Storage**: Create a storage account + container for release bundles.

## Configure the workflow
Set the following (ideally via repo/environment secrets):
- `AZURE_TENANT_ID`, `AZURE_SUBSCRIPTION_ID`, `AZURE_CLIENT_ID`
- `AZURE_STORAGE_ACCOUNT`, `AZURE_STORAGE_CONTAINER`, `BLOB_PREFIX`
- `AZ_RESOURCE_GROUP`, `AZ_VM_NAME`, `AZ_VM_LOCATION`, `APP_DIR`

## Deploy flow
1) Login with OIDC via `azure/login@v2`.
2) Zip `scripts/ + app/` → `dist/bundle-<sha>.zip`.
3) Upload to blob; generate read‑only SAS valid for ~30 minutes.
4) `az ssh vm` into the VM and run `scripts/az_vm_run_deploy.sh`, which executes hooks and a health check.

## Safer rollouts
- Place VMs behind an Azure Load Balancer/Application Gateway and drain connections.
- For fleets, prefer VM Scale Sets and roll through update domains or use image‑based rollout.

## Notes
- Long remote command is split and safely quoted for readability.
- You can replace SAS with Managed Identity on the VM and use `az storage blob download --auth-mode login`.
