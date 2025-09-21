# GitLab CI/CD → GCP VM (GCE)

Deploy from **GitLab CI** to a **GCE VM** using **Workload Identity Federation (WIF)** with **GitLab OIDC** (no JSON keys).

## Contents
- `.gitlab-ci.yml` - OIDC token → WIF external_account creds → zip → GCS upload → SSH orchestrator
- `scripts/gcp_vm_run_deploy.sh` - orchestrates stop → before → rsync → after → start → validate
- `scripts/*.sh` - lifecycle hooks
- `app/` - app payload

## One‑time GCP setup
1) **Workload Identity**: Create Pool + Provider (issuer: `https://gitlab.com`). Configure attribute mapping/conditions to lock to your project/repo/branch.
2) **Service Account**: Grant minimal roles:
   - `roles/storage.objectAdmin` on your bucket/prefix (or narrower)
   - `roles/compute.osAdminLogin` (+ `roles/compute.instanceAdmin.v1` if needed)
   - `roles/iap.tunnelResourceAccessor` if using IAP SSH
3) **Enable APIs**: `iam`, `iamcredentials`, `storage`, `compute`.
4) **GCE VM**: Public IP or IAP tunnel; OS Login configured if using IAP.

## Configure `.gitlab-ci.yml`
- Set `GCP_PROJECT_ID`, `WIF_PROVIDER_RESOURCE`, and `IMPERSONATE_SERVICE_ACCOUNT`.
- Set `GCS_BUCKET`, `GCS_PREFIX`, `GCE_INSTANCE`, `GCE_ZONE`, `APP_DIR`.
- If you use IAP for SSH, set `USE_IAP: "true"` and ensure the SA has the IAP role.
- Ensure both jobs run on your release branch (rules currently target `$CI_DEFAULT_BRANCH`).

## How the auth works (no keys)
- GitLab injects a short‑lived OIDC ID token into `$GCP_ID_TOKEN` (see `id_tokens`).
- The pipeline writes that token to `/tmp/wif/idtoken.jwt` and creates an **external_account** credentials file that:
  - Points to the token file,
  - Specifies your WIF provider (`audience`),
  - Requests **service account impersonation** for `IMPERSONATE_SERVICE_ACCOUNT`.
- `gcloud auth login --cred-file=$GOOGLE_APPLICATION_CREDENTIALS` activates ADC for `gcloud/gsutil`.

## Flow
1. Package `scripts/ + app/` into `dist/bundle-<sha>.zip`.
2. Upload to GCS: `gs://<bucket>/<prefix>/bundle-<sha>.zip`.
3. `gcloud compute ssh` into the VM (IAP optional) and run `gcp_vm_run_deploy.sh`.
4. Orchestrator executes lifecycle hooks and a health check.

## Tips
- For fleets: iterate over multiple instances or use a Managed Instance Group with rolling updates.
- For near zero‑downtime: put VMs behind a LB and drain connections during rollout.
