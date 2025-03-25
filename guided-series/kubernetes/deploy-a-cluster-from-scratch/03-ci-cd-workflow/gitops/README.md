CI/CD GitOps using ArgoCD, Github Actions, k3s

1. Copy the `k3s-default-patch` content into your repository which you created in Part 1.
2. Adjust the repo url
# charts/root-app/templates/nextjs-app.yaml

spec:
  project: default
  source:
    repoURL: https://github.com/technicaldirector/k3s-default.git
3. 