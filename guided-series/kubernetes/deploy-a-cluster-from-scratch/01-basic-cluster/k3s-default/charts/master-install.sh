# Install our ingress controller
kustomize build ./charts/nginx-ingress --enable-helm | kubectl apply -f -

# Wait for the ingress controller to be ready
kubectl wait --for=condition=available --timeout=600s deployment/ingress-nginx-controller -n ingress-nginx

# Install ArgoCD
kustomize build ./charts/argocd --enable-helm | kubectl apply -f -

# Patch argocd to use kustomize
kubectl patch configmap argocd-cm -n argocd --patch '{"data": {"kustomize.buildOptions": "--enable-helm"}}'

# Install ArgoCD root app
helm template ./charts/root-app | kubectl apply -f -
