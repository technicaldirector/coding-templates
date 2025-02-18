# ArgoCD, Helm, and Nginx Ingress Setup

This repository provides a step-by-step guide and configuration files to set up ArgoCD, Helm, and Nginx Ingress on a Kubernetes cluster using Helmfile. The setup is designed to be declarative, allowing you to manage your Kubernetes applications and infrastructure as code.

# Guide

Read more about how to create this setup here [URL]

## Key Features

- **ArgoCD Setup**: Automate the deployment and management of applications using ArgoCD.
- **Helmfile Integration**: Use Helmfile to manage Helm charts and dependencies in a declarative way.
- **Nginx Ingress Controller**: Deploy and configure Nginx Ingress for managing external access to your services.
- **Self-Managed ArgoCD**: Configure ArgoCD to manage itself, enabling updates via Git commits.
- **Private Repository Support**: Instructions for integrating ArgoCD with private Git repositories using GitHub App credentials.

## Getting Started

1. **Prerequisites**: Ensure you have a Kubernetes cluster (e.g., K3s), Helm, Helmfile, and a public Git repository.
2. **Clone the Repository**: Clone this repository to your local machine.
3. **Follow the Guide**: Use the provided `master-helmfile.yaml` and other configuration files to set up ArgoCD, Helm, and Nginx Ingress.
4. **Deploy Applications**: Add your applications to the `root-app` Helm chart and let ArgoCD manage them automatically.

