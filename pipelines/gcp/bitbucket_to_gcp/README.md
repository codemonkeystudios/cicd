# Bitbucket → GCP VM (GCE)

This bundle deploys from **Bitbucket Pipelines** to a **GCE VM** using **Workload Identity Federation** (no JSON keys).

## Files
- `bitbucket-pipelines.yml` - OIDC → WIF auth, zip, GCS upload, SSH to VM, orchestrator
- `scripts/gcp_vm_run_deploy.sh` - orchestrates the lifecycle on the VM
- `scripts/*.sh` - lifecycle hooks
- `app/` - app payload

## Setup (GCP)
1. Create WIF Pool + Provider (issuer for your workspace; lock to repo/branch).
2. Create a Service Account and grant Storage + Compute roles (and IAP role if tunneling).
3. Enable `iam`, `iamcredentials`, `compute`, `storage` APIs.
4. Ensure VM is reachable (public IP or IAP) and OS Login configured if using IAP.

## Configure variables (Bitbucket repo settings → Variables)
- `GCP_PROJECT_ID`
- `WIF_PROVIDER_RESOURCE` (full provider path)
- `IMPERSONATE_SERVICE_ACCOUNT` (SA email)
- `GCS_BUCKET`, `GCS_PREFIX`
- `GCE_INSTANCE`, `GCE_ZONE`
- `APP_DIR`
- `USE_IAP`

## Flow
1) Package `scripts/ + app/` into `dist/bundle-<commit>.zip`
2) Upload to GCS
3) SSH to VM and run `gcp_vm_run_deploy.sh` (stop → before → rsync → after → start → validate)
