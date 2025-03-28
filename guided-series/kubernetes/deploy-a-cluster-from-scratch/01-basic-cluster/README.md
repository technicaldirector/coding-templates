# ArgoCD with Helm and Nginx Ingress

## Overview

This guide will help you boot up ArgoCD with Helm and an Nginx ingress. Additionally, it will enable you to use a private repository in ArgoCD.

For more details, check out the [full guide](url).

---

## Prerequisites

- Install k3s on your server ([standalone guide](url))
- Install Helm on your server ([standalone guide](url))
- Install Helmfile on your server ([standalone guide](url))

---

## Setup Steps

### Repository Setup

1. **Create a New Repository**  
   Create a new repository to store your configuration files.

2. **Copy Content**  
   Copy the content of `k3s-default` into the newly created repository.

### Configuration Adjustments

3. **Adjust the Ingress URL**  
   Update the ingress URL in the `argocd-ingress.yaml` file:
   ```yaml
   # charts/argocd/templates/ingresses/argocd-ingress.yaml
   ...
   spec:
     ingressClassName: nginx  # Ensure this matches your Ingress Controller
     rules:
     - host: argocd.yourdomain.com  # Update to your URL
   ...
   ```

4. **Adjust the Repository URL**  
   Update the repository URL in the following files:
   ```yaml
   # charts/root-app/templates/argocd-app.yaml
   # charts/root-app/templates/nginx-ingress-app.yaml
   # charts/root-app/templates/root-app.yaml
   ...
   source:
     repoURL: https://github.com/technicaldirector/k3s-default.git  # Update to your repository URL
   ...
   ```

### Secret Management

5. **Create a GitHub Application**  
   Follow the [standalone guide](url) to create a GitHub application.

6. **Edit the ArgoCD Secret File**  
   Modify `charts/argocd/templates/secrets/argocd-secret.yaml` with your content.\
   ⚠️ **Important:** Do not push the secret file yet!

7. **Store the Secret Securely**  
   Store the secret in GitHub securely by following the [guided series](url).

### Deployment

8. **Push Changes and Clone Repository**  
   Push your changes to the repository and clone it to your server.

9. **Apply Deployments Using Helmfile**  
   Run the following command to apply the deployments:
   ```sh
   helmfile -f [path to master-helmfile] apply
   ```

---

## Access ArgoCD

After applying the deployments, you can reach ArgoCD on the defined ingress.

### Retrieve ArgoCD Password

To get the ArgoCD admin password, run the following command:
```sh
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 --decode
```

---
