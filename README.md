[![Build Status](https://github.com/shelmangroup/distroless-k8s/actions/workflows/release.yaml/badge.svg)](https://github.com/shelmangroup/distroless-k8s/actions/workflows/release.yaml)

# distroless-k8s: A minimal Kubernetes tools container

`ghcr.io/shelmangroup/distroless-k8s` is a CI/CD optimized container image for working with Kubernetes. 
Made with [apko](https://github.com/chainguard-dev/apko), [melange](https://github.com/chainguard-dev/melange) and :sparkling_heart:.

Automatically built, reproducible, images with kubectl, kustomize, helm and a few other commonly used tools.
This project puts emphasis on automatic regular updates, security, and keeping the image size as small as possible.

The images are currently built for `amd64` and `arm64` architectures. If you'd like to see other architectures supported, [please submit an issue](https://github.com/shelmangroup/distroless-k8s/issues/new).

## Usage

The images are published to GitHub Container Registry at `ghcr.io/shelmangroup/distroless-k8s`.
They are also tagged with the kubernetes/kubectl full and minor version to make it easy to match a given cluster for compatibility.

### Example:
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

## Image size

The tool binaries are stripped and compressed with [UPX](https://upx.github.io/) to reduce the size of the image (from ~160MiB to ~50MiB). Often, only one or two of the tools are needed in a use case so optimizing for a smaller download makes sense, the tradeoff being a short decompression time when running a tool.
