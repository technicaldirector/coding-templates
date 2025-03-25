# CloudnativePG in Kubernetes

## Overview

This guide will help you deploy CloudnativePG in your Kubernetes cluster using ArgoCD. Additionally, it will walk you through setting up the CloudnativePG operator and necessary components for managing PostgreSQL databases in a cloud native way.

For more details, check out the [full guide](https://cloudnative-pg.io/documentation/).

---

## Prerequisites

- ✅ [Deploy a cluster from scratch | Part 1 | Basic Cluster](../../../01-basic-cluster/README.md) completed
- ✅ Access to a Git repository for your ArgoCD configuration
- ✅ `kubectl` access to your Kubernetes cluster

---

## Setup Steps

### Prepare Repository Configuration

1. **Copy Configuration Files**  
   Copy the `k3s-default-patch` content into your repository which you created in Part 1.

2. **Update Repository URLs**  
   Adjust the repository URLs in your ArgoCD application file for the cluster and operator:
   
   ```yaml
   # charts/root-app/templates/cloudnative-pg-app.yaml
   ---
   ...
   spec:
     project: default
     source:
       repoURL: https://github.com/technicaldirector/k3s-default.git
    ...
    ---
   ...
   spec:
     project: default
     source:
       repoURL: https://github.com/technicaldirector/k3s-default.git
    ...
    ---
   ```

### Install and Configure CloudnativePG

3. **Install CloudnativePG Plugin**  
   Install the cloudnative-pg kubectl plugin on your master node:
   
   ```bash
   curl -sSfL https://github.com/cloudnative-pg/cloudnative-pg/raw/main/hack/install-cnpg-plugin.sh | sudo sh -s -- -b /usr/local/bin
   ```

4. **Verify Installation**  
   Ensure the plugin is correctly installed:
   
   ```bash
   kubectl cnpg version
   ```

5. **Deploy CloudnativePG with ArgoCD**  
   Apply your ArgoCD application configuration:
   
   ```bash
   kubectl apply -f charts/root-app/templates/cloudnative-pg-app.yaml
   ```

---

## Additional Information

⚠️ **Important:** Make sure your Kubernetes cluster has sufficient resources to run PostgreSQL workloads.

🔍 **Validation:** You can check the status of your CloudnativePG deployment with:
```bash
kubectl get pods -n cloudnative-pg
```

For more detailed instructions and troubleshooting, refer to the [CloudnativePG documentation](https://cloudnative-pg.io/documentation/).