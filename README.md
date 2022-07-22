# Kubernetes Tools

Reproducible images with kubectl, kustomize, helm and some other useful tools for automated deployment scenarios.

Made with [apko](https://github.com/chainguard-dev/apko), [melange](https://github.com/chainguard-dev/melange) and :sparkling_heart:.

The static binaries are stripped and compressed with [UPX](https://upx.github.io/) to reduce the size of the image (from ~160MiB to ~50MiB). Often, only one or two of the tools are needed in a use case, so optimizing for a smaller download makes sense, the tradeoff being a short decompression time when running a tool.

The images are published to GitHub Container registry at `ghcr.io/shelmangroup/distroless-k8s`.

Images are tagged with the kubernetes/kubectl version to make it easy to match a given cluster:


## Example:
```
% podman run --rm -it ghcr.io/shelmangroup/distroless-k8s:1.24
 _     ___
| |   / _ \           kubectl: v1.24.3
| | _| (_) |___       kustomize: v4.5.5
| |/ /> _ </ __|      kapp: v0.49.0
|   <| (_) \__ \      kbld: v0.34.0
|_|\_\\___/|___/      helm: v3.9.1


More info: https://github.com/shelmangroup/distroless-k8s

/ $
```

```
% podman run --rm -it distroless-k8s-dev kustomize version
{Version:kustomize/v4.5.5 GitCommit:daa3e5e2c2d3a4b8c94021a7384bfb06734bcd26 BuildDate:2022-05-20T20:25:40Z GoOs:linux GoArch:amd64}
```

## Installed tools

- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- [kustomize](https://github.com/kubernetes-sigs/kustomize)
- [helm](https://helm.sh/)
- [kapp](https://carvel.dev/kapp/)
- [kbld](https://carvel.dev/kbld/)

