# GitHub → AWS CodeDeploy (EC2) - How‑To

Deploy from **GitHub Actions** to **EC2** via **AWS CodeDeploy** using **OIDC** (no keys).
Zip `appspec.yml` + `scripts/` + `app/`, upload to S3, trigger CodeDeploy, wait for success.

## Files
- `.github/workflows/deploy.yml` - OIDC auth, zip, S3 upload, CodeDeploy create + wait.
- `appspec.yml` - CodeDeploy spec (files + hooks).
- `scripts/*.sh` - lifecycle scripts.
- `app/` - put your app here (placeholder included).

## Setup
1. Create an **IAM Role** trusted by GitHub OIDC (scope to your repo/branch).
2. Grant minimal permissions (S3 + CodeDeploy).
3. Create CodeDeploy Application + Deployment Group. Install the CodeDeploy agent on EC2.

## Configure
- In `deploy.yml`, set `role-to-assume` and env vars (`AWS_REGION`, `S3_BUCKET`, etc.).
- Ensure `appspec.yml` is at repo root; scripts executable (`chmod +x scripts/*.sh`).

## Safer Rollouts
- Use `CodeDeployDefault.HalfAtATime` for rolling.
- For Blue/Green with ALB, configure a Blue/Green deployment group and swap traffic.
