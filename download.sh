#!/bin/sh
set -feu
ARCHS="amd64 arm64"

versions=$(dirname "$(readlink -f "$0")")/VERSIONS
. "$versions"

for arch in $ARCHS; do
	curl -fsLZ \
		-o "kubectl-${arch}" "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/${arch}/kubectl" \
		-o "kapp-${arch}" "https://github.com/carvel-dev/kapp/releases/download/${KAPP_VERSION}/kapp-linux-${arch}" \
		-o "kbld-${arch}" "https://github.com/carvel-dev/kbld/releases/download/${KBLD_VERSION}/kbld-linux-${arch}"

	curl -fsL "https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2F${KUSTOMIZE_VERSION}/kustomize_${KUSTOMIZE_VERSION}_linux_${arch}.tar.gz" | tar xz
	mv kustomize "kustomize-${arch}"

	curl -fsL "https://get.helm.sh/helm-${HELM_VERSION}-linux-${arch}.tar.gz" | tar xz
	mv "linux-${arch}/helm" "helm-${arch}"
	rm -rf "linux-${arch}"
done
