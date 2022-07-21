# Kubernetes Tools

Reproducible images with kubectl, kustomize and some other useful tools for automated deployment.

Made with [apko](https://github.com/chainguard-dev/apko).

Tagged with the kubernetes/kubectl version to make it easy to match a given cluster.

## Example:
```
% podman run --rm -it ghcr.io/shelmangroup/distroless-k8s:1.24
 _     ___
| |   / _ \           kubectl: v1.24.3
| | _| (_) |___       kustomize: v4.5.5
| |/ /> _ </ __|      kapp: v0.49.0
|   <| (_) \__ \      kbld: v0.34.0
|_|\_\\___/|___/


More info: https://github.com/shelmangroup/distroless-k8s

/ $
```

## Installed tools

- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- [kustomize](https://github.com/kubernetes-sigs/kustomize)
- [kapp](https://carvel.dev/kapp/)
- [kbld](https://carvel.dev/kbld/)

