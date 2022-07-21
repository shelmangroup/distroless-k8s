#!/bin/sh
set -feu
ARCHS="amd64 arm64"

versions=$(dirname "$(readlink -f "$0")")/VERSIONS
. "$versions"

for arch in $ARCHS; do
  curl -fsLZ \
    -o "kubectl-${arch}" "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/${arch}/kubectl" \
    -o "kapp-${arch}" "https://github.com/vmware-tanzu/carvel-kapp/releases/download/${KAPP_VERSION}/kapp-linux-${arch}" \
    -o "kbld-${arch}" "https://github.com/vmware-tanzu/carvel-kbld/releases/download/${KBLD_VERSION}/kbld-linux-${arch}"

  curl -fsL -O "https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2F${KUSTOMIZE_VERSION}/kustomize_${KUSTOMIZE_VERSION}_linux_${arch}.tar.gz"
  tar xzf "kustomize_${KUSTOMIZE_VERSION}_linux_${arch}.tar.gz"
  mv kustomize kustomize-${arch}
done
