# platform-gitops

Central GitOps repository for managing application deployments via Argo CD on OpenShift.

## Architecture

This repo uses the **App of Apps** pattern:

1. **argocd-apps/** — A Helm chart that generates one Argo CD `Application` CRD per app, per environment
2. **helm-charts/charts/universal/** — A single universal Helm chart used by all applications regardless of technology stack

## Adding a New Application

Add an entry to `argocd-apps/values/base.yaml`:

```yaml
applications:
  - name: my-new-app        # Must match the Azure DevOps repo name
    projectName: MyProject   # Azure DevOps project name (used for namespace)
    technology: dotnet       # node | dotnet | java | python
    platform: azure          # azure | onprem
    port: 8080               # Only if non-standard for the technology
```

That's it. The pipeline handles `imageRepo`, `imageTag`, and all other details.

## Cluster Routing

Apps are routed to clusters based on `platform` + environment:

| Platform | Nonprod (dev/qa/uat) | Prod |
|----------|---------------------|------|
| azure | azure-np | azure-prod |
| onprem | np | prod |

## Namespace Convention

- **Nonprod:** `{projectName}-{environment}` (e.g. `MyProject-dev`)
- **Prod:** `{projectName}` (e.g. `MyProject`)

## Environments

| File | Cluster | Purpose |
|------|---------|---------|
| `values/nonprod-dev.yaml` | dev | Development |
| `values/nonprod-qa.yaml` | qa | QA / Integration testing |
| `values/nonprod-uat.yaml` | uat | User acceptance testing |
| `values/prod.yaml` | prod | Production |

## Technology Defaults

| Tech | Default Port | Health Path | Memory | CPU |
|------|-------------|-------------|--------|-----|
| node | 3000 | /health | 256Mi | 250m |
| dotnet | 8080 | /healthz | 512Mi | 500m |
| java | 8080 | /actuator/health | 768Mi | 500m |
| python | 8000 | /health | 256Mi | 250m |
