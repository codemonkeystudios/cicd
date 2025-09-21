# GitHub → Google Cloud (GCE VM) - How‑To

This pipeline uses **GitHub OIDC + GCP Workload Identity Federation** to avoid JSON keys,
packages your app, uploads to **GCS**, then SSHes to a **GCE VM** to run lifecycle hooks.

## Files
- `.github/workflows/deploy_gcp.yml` - OIDC/WIF auth, zip, GCS upload, SSH orchestrator
- `scripts/gcp_vm_run_deploy.sh` - stop → before → rsync → after → start → validate
- `scripts/*.sh` - lifecycle hooks
- `app/` - your app

## Setup (GCP)
1. Create WIF Pool + Provider (trust GitHub OIDC; limit to your repo/branch).
2. Create Service Account; grant minimal roles: storage.objectAdmin, compute.osAdminLogin, compute.instanceAdmin.v1 (plus iap.tunnelResourceAccessor if using IAP).
3. Enable APIs: iam, iamcredentials, storage, compute.
4. Ensure VM reachable (public IP or IAP). OS Login recommended for IAP.

## Configure
Edit env values in the workflow (`GCP_PROJECT_ID`, `GCP_WIF_PROVIDER`, `GCP_SERVICE_ACCOUNT`, `GCS_BUCKET`, `BLOB_PREFIX`, `GCE_INSTANCE`, `GCE_ZONE`, `APP_DIR`, `USE_IAP`).

## Flow
1) Authenticate via WIF; 2) zip code; 3) `gsutil cp` to bucket; 4) `gcloud compute ssh` to VM; 5) orchestrator runs hooks and health check.

## Notes
- Long remote command is split and quoted to keep things readable.
- For fleets, prefer MIG + rolling update or deploy to a subset of instances first.
