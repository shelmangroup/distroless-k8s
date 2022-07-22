#!/usr/bin/env bash
set -eu -o pipefail

HELM_VERSION=$(curl -fsL https://api.github.com/repos/helm/helm/releases/latest | jq -r '.tag_name')
KAPP_VERSION=$(curl -fsL https://api.github.com/repos/vmware-tanzu/carvel-kapp/releases/latest | jq -r '.tag_name')
KBLD_VERSION=$(curl -fsL https://api.github.com/repos/vmware-tanzu/carvel-kbld/releases/latest | jq -r '.tag_name')
KUBECTL_VERSION=$(curl -fsL https://dl.k8s.io/release/stable.txt)

kustomize_release=$(curl -s https://api.github.com/repos/kubernetes-sigs/kustomize/releases | /usr/bin/jq -r '.[].tag_name | select(contains("kustomize"))' \
  | sort -rV | head -n 1)
KUSTOMIZE_VERSION=$(basename "${kustomize_release}")

here=$(dirname "$(readlink -f "$0")")

KUBECTL_SEMVER="${KUBECTL_VERSION//v/}"
KUBECTL_SEMVER_MINOR=$(echo "${KUBECTL_SEMVER}" | sed -e 's/\.[0-9]*$//')

cat >"${here}/VERSIONS" <<EOF
HELM_VERSION=${HELM_VERSION}
KAPP_VERSION=${KAPP_VERSION}
KBLD_VERSION=${KBLD_VERSION}
KUBECTL_SEMVER=${KUBECTL_SEMVER}
KUBECTL_SEMVER_MINOR=${KUBECTL_SEMVER_MINOR}
KUBECTL_VERSION=${KUBECTL_VERSION}
KUSTOMIZE_VERSION=${KUSTOMIZE_VERSION}
EOF

## FIXME: leaving these out until https://github.com/chainguard-dev/apko/issues/301 is fixed
# apko_yaml="${here}/apko.yaml"
# yq -Y -i ".environment.HELM_VERSION = \"${HELM_VERSION}\"" "${apko_yaml}"
# yq -Y -i ".environment.KAPP_VERSION = \"${KAPP_VERSION}\"" "${apko_yaml}"
# yq -Y -i ".environment.KBLD_VERSION = \"${KBLD_VERSION}\"" "${apko_yaml}"
# yq -Y -i ".environment.KUBECTL_VERSION = \"${KUBECTL_VERSION}\"" "${apko_yaml}"
# yq -Y -i ".environment.KUSTOMIZE_VERSION = \"${KUSTOMIZE_VERSION}\"" "${apko_yaml}"

melange_yaml="${here}/melange.yaml"
yq -Y -i ".package.version = \"${KUBECTL_SEMVER}\"" "${melange_yaml}"

tmpdir=$(mktemp -d)
trap 'rm -rf $tmpdir' EXIT

cd "${tmpdir}"
"${here}/download.sh"
sha256sum -- * >"${here}/DIGESTS"
