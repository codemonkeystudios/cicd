# GitLab CI/CD → Azure VM (AAD SSH)

Deploy from **GitLab CI** to an **Azure Linux VM** using **OIDC + Federated Credentials** (no client secrets),
store bundles in **Azure Blob Storage**, then use **az ssh vm** (AAD) to run an on‑box orchestrator.

## Contents
- `.gitlab-ci.yml` — OIDC token → `az login --federated-token` → zip → blob upload + short‑lived SAS → AAD SSH → orchestrator
- `scripts/az_vm_run_deploy.sh` — orchestrates stop → before → rsync → after → start → validate
- `scripts/*.sh` — lifecycle hooks
- `app/` — your application payload

## One‑time Azure setup
1. **Entra ID App Registration** (Service Principal) with a **Federated Credential** for this GitLab project/ref.
2. **Role assignments** to that SPN:
   - `Storage Blob Data Contributor` on your storage account or container.
   - `Virtual Machine Administrator Login` (or `Virtual Machine User Login` + sudo mechanism) on the VM or resource group.
   - (Optional) `Reader` on the VM resource group.
3. **VM**: Enable **AADLoginForLinux** extension (for AAD SSH). Ensure outbound internet.
4. **Storage**: Create a storage account + container for release bundles.

## Configure `.gitlab-ci.yml`
Set the following GitLab CI/CD variables (masked/protected where appropriate):
- `AZURE_TENANT_ID`, `AZURE_SUBSCRIPTION_ID`, `AZURE_CLIENT_ID`
- `AZURE_STORAGE_ACCOUNT`, `AZURE_STORAGE_CONTAINER`, `BLOB_PREFIX`
- `AZ_RESOURCE_GROUP`, `AZ_VM_NAME`, `AZ_VM_LOCATION`, `APP_DIR`

The job also requests an OIDC token via:
```yaml
id_tokens:
  AZURE_ID_TOKEN:
    aud: "api://AzureADTokenExchange"   # match your federated credential audience
```

## Deploy flow
1) Login with OIDC via `az login --service-principal --federated-token` (no secret).
2) Zip `scripts/ + app/` → `dist/bundle-<sha>.zip`.
3) Upload to blob; generate read‑only SAS (~30 minutes).
4) `az ssh vm` into the VM and run `scripts/az_vm_run_deploy.sh`, which executes hooks and a health check.

## Safer rollouts
- Place VMs behind an Azure Load Balancer/Application Gateway and drain connections.
- For fleets, prefer VM Scale Sets and rolling upgrades (or Image‑based rollouts with Shared Image Gallery).

## Notes
- Long remote command is split and safely quoted for readability.
- You can replace SAS with Managed Identity on the VM and use `az storage blob download --auth-mode login`.
