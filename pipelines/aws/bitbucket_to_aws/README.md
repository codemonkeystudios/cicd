# Bitbucket Pipelines → AWS CodeDeploy (EC2) - How‑To

Deploy from **Bitbucket Pipelines** to **EC2** via **AWS CodeDeploy** using **OIDC** (no keys).
Zip `appspec.yml` + `scripts/` + `app/`, upload to S3, trigger CodeDeploy, wait for success.

## Files
- `bitbucket-pipelines.yml` - OIDC auth, zip, S3 upload, CodeDeploy create + wait.
- `appspec.yml` - CodeDeploy spec (files + hooks).
- `scripts/*.sh` - lifecycle scripts.
- `app/` - put your app here (placeholder included).

## Setup
1. Create an **IAM Role** trusted by Bitbucket OIDC (issuer shown in comments above; audience `sts.amazonaws.com`).
2. Scope the trust policy subject to your repo/branch (e.g., `repo:<workspace>/<repo>:ref:refs/heads/main`).
3. Grant minimal permissions (S3 + CodeDeploy).
4. Create CodeDeploy Application + Deployment Group. Install the CodeDeploy agent on EC2.

## Configure
Set these Repository variables in Bitbucket:
- `AWS_REGION`
- `S3_BUCKET`
- `S3_KEY_PREFIX`
- `CODEDEPLOY_APPLICATION`
- `CODEDEPLOY_DEPLOYMENT_GROUP`
- `AWS_ROLE_ARN`

## Safer Rollouts
- Use `CodeDeployDefault.HalfAtATime` for rolling.
- For Blue/Green with ALB, configure a Blue/Green deployment group and swap traffic.
