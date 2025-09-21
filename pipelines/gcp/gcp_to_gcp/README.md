# Cloud Source Repositories → Cloud Build → GCE VM

Deploy from a **GCP Source Repository** via **Cloud Build** to a **Compute Engine VM**.
No long‑lived keys; Cloud Build uses its Service Account. Bundles (scripts + app)
are stored in **GCS**, then an orchestrator runs on the VM over SSH (IAP optional).

## Contents
- `cloudbuild.yaml` - package → upload to GCS → SSH to VM → orchestrator
- `scripts/gcp_vm_run_deploy.sh` - stop → before → rsync → after → start → validate
- `scripts/*.sh` - lifecycle hooks
- `app/` - placeholder payload

## One‑time GCP setup
1. **Cloud Build Trigger** connected to your repo, pointing to `cloudbuild.yaml`.
2. **Service Account** used by Cloud Build with roles:
   - `roles/storage.objectAdmin` (scope to your bucket/prefix)
   - `roles/compute.osAdminLogin`
   - `roles/compute.instanceAdmin.v1`
   - `roles/iap.tunnelResourceAccessor` (ONLY if using IAP SSH)
3. **Enable APIs**: cloudbuild, compute, storage, iam, iamcredentials.
4. **GCE VM** reachable (public IP or IAP); configure OS Login if using IAP.

## Configure
- In `cloudbuild.yaml` substitutions, set: `_PROJECT_ID`, `_GCS_BUCKET`, `_BLOB_PREFIX`,
  `_GCE_INSTANCE`, `_GCE_ZONE`, `_APP_DIR`, `_USE_IAP`.
- Optionally set `serviceAccount:` to a custom deployer SA.

## Flow
1. Cloud Build zips `scripts/ + app/` → `dist/bundle-<sha>.zip`.
2. Uploads to `gs://<bucket>/<prefix>/bundle-<sha>.zip`.
3. SSH to VM (IAP optional) and run `gcp_vm_run_deploy.sh` to execute hooks + health check.

## Safer rollouts
- Put VMs behind a Load Balancer and drain connections before restart.
- For fleets, use a Managed Instance Group and rolling updates (or loop instances).

## Tips
- Keep long commands split for readability.
- Ensure scripts are executable in git (`chmod +x scripts/*.sh`).

