# Securely Store Kubernetes Secrets in GitHub

## Overview

This guide will help you securely store Kubernetes secrets in GitHub. Additionally, it will ensure that your secrets are encrypted and safely managed within your repository.

For more details, check out the [full guide](url).

---

## Prerequisites

- [Deploy a cluster from scratch | Part 1 | Basic Cluster](url) followed up to step 7.
- A GitHub repository created in Part 1.

---

## Setup Steps

### Create and Configure Your Repository

1. **Copy the k3s-default-patch content**  
   Copy the `k3s-default-patch` content into your repository which you created in Part 1.

2. **Update Repository URLs**  
   Adjust the repository URLs in your ArgoCD application:
   
   ```yaml
   # charts/root-app/templates/sealed-secrets-app.yaml
   ...
   spec:
     project: default
     source:
       repoURL: https://github.com/technicaldirector/k3s-default.git
    ...
    ```

3. **Apply the helmfile**
    Start the sealed secrets container using helmfile.
    ```sh
    helmfile -f [path to /charts/sealed-secrets/helmfile.yaml] apply
    ```

4. **Install kubeseal in your CLI**  
   Install `kubeseal` to encrypt your secrets.
   ```sh
   KUBESEAL_VERSION='0.28.0' # Replace with your desired version
   curl -OL "https://github.com/bitnami-labs/sealed-secrets/releases/download/v${KUBESEAL_VERSION}/kubeseal-${KUBESEAL_VERSION}-linux-amd64.tar.gz"
   tar -xvzf kubeseal-${KUBESEAL_VERSION}-linux-amd64.tar.gz kubeseal
   sudo install -m 755 kubeseal /usr/local/bin/kubeseal
   ```
   
   Or you can directly install the newest version with the correct architecture by using the install script
   ```sh
   curl -sSfL https://github.com/technicaldirector/coding-templates/raw/main/guided-series/kubernetes/02-securly-store-k3s-secrets/assets/install-kubeseal.sh | sudo sh -s -- -b /usr/local/bin
   ```

5. **Encrypt your secret**  
   Use `kubeseal` to encrypt your secret file.
   ```sh
   kubeseal -f charts/argocd/templates/secrets/argocd-secret.yaml -o yaml > charts/argocd/templates/secrets/argocd-secret.yaml
   ```

6. **Push the sealed secret to your repository**  
   Push the sealed secret to your repository. Argo CD will automatically apply the secret to your cluster.

---

