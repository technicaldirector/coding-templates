# Deploy Cert-Manager on Kubernetes with Cloudflare DNS

## Overview

This guide will help you set up cert-manager with Cloudflare DNS integration on your Kubernetes cluster. Additionally, it will ensure that your cluster can automatically provision and manage SSL certificates for secure ingress access.

For more details, check out the [full guide](https://example.com/cert-manager-guide).

---

## Prerequisites

- [Deploy a cluster from scratch | Part 1 | Basic Cluster](https://example.com/k8s-part1)
- A domain registered in Cloudflare
- Access to Cloudflare account with admin privileges
- GitHub repository with your ArgoCD configuration from Part 1

---

## Setup Steps

### Cloudflare Configuration

1. **Configure DNS in Cloudflare**  
   Add your domain to Cloudflare and create an API token:

   Under **Profile > API Tokens**, create a token with:
   - Permissions: `Zone - DNS - Edit` + `Zone - Zone - Read`
   - Zone Resources: `Include - All Zones`

2. **Configure SSL/TLS Settings**  
   In Cloudflare dashboard, go to SSL/TLS section and switch to **Full(strict)** mode.
   
   ⚠️ **Important**: This prevents redirect loops between Cloudflare (HTTP) and your ingress (HTTPS).

### Repository Configuration

3. **Update Your Repository**  
   Copy the `k3s-default-patch` content into your repository from Part 1. You'll need to overwrite:
   - `charts/argocd/values.yaml`
   - `charts/argocd/templates/ingresses/argocd-ingress.yaml`

4. **Update Repository URLs**  
   Adjust the repository URLs in your ArgoCD application:
   
   ```yaml
   # charts/root-app/templates/cert-manager-app.yaml
   spec:
     project: default
     source:
       repoURL: https://github.com/technicaldirector/k3s-default.git
       # ...rest of config
   ```

### Certificate Configuration

5. **Configure Cert-Manager Secret**  
   Add your Cloudflare API token to your secret:

   ```yaml
   # charts/cert-manager/templates/secrets/cert-manager-secret.yaml
   apiVersion: v1
   kind: Secret
   metadata:
     name: cloudflare-api-token-secret
     namespace: cert-manager
   type: Opaque
   stringData:
     api-token: "<your-token-here>"
   ```

6. **(Optional) Encrypt Your Secret**  
   If you're using sealed secrets, encrypt your secret file:
   
   ```sh
   kubeseal -f charts/cert-manager/templates/secrets/cert-manager-secret.yaml -o yaml > charts/cert-manager/templates/secrets/cert-manager-secret.yaml
   ```

7. **Configure Let's Encrypt Issuer**  
   Add your email address to the Let's Encrypt issuer:
   
   ```yaml
   # charts/cert-manager/templates/issuers/cert-manager-issuer.yaml
   apiVersion: cert-manager.io/v1
   kind: ClusterIssuer
   metadata:
     name: letsencrypt-prod
   spec:
     acme:
       server: https://acme-v02.api.letsencrypt.org/directory
       email: your-email@example.com
       # ...rest of config
   ```

### Ingress Configuration

8. **Update ArgoCD Ingress**  
   Configure your ingress to use the certificates:
   
   ```yaml
   # charts/argocd/templates/ingresses/argocd-ingress.yaml
   apiVersion: networking.k8s.io/v1
   kind: Ingress
   metadata:
     name: argocd-server
   spec:
     ingressClassName: nginx 
     rules:
     - host: argocd.your-domain.com # Update with your domain
       http:
         paths:
         - path: /
           pathType: Prefix
           backend:
             service:
               name: argocd-server  
               port:
                 number: 443 
     tls:
     - hosts:
       - argocd.your-domain.com # Update with your domain
       secretName: your-domain-wildcard-tls # Update secret name
   ```

9. **Deploy Changes**  
   Push the new content to your repository. ArgoCD will automatically detect and apply the changes, enabling SSL for your services.

---

## Additional Information
- Cert-manager will automatically renew certificates before they expire
- You can confirm certificate issuance by checking cert-manager logs or examining the certificate resources
- For troubleshooting certificate issues, check cert-manager's "Certificate" and "CertificateRequest" resources