#!/usr/bin/env bash
set -eu -o pipefail

KUBECTL_VERSION=$(curl -fsL https://dl.k8s.io/release/stable.txt)
kustomize_release=$(curl -s https://api.github.com/repos/kubernetes-sigs/kustomize/releases | /usr/bin/jq -r '.[].tag_name | select(contains("kustomize"))' \
  | sort -rV | head -n 1)

KUSTOMIZE_VERSION=$(basename "${kustomize_release}")

KAPP_VERSION=$(curl -fsL https://api.github.com/repos/vmware-tanzu/carvel-kapp/releases/latest | jq -r '.tag_name')

KBLD_VERSION=$(curl -fsL https://api.github.com/repos/vmware-tanzu/carvel-kbld/releases/latest | jq -r '.tag_name')

here=$(dirname "$(readlink -f "$0")")

cat >"${here}/VERSIONS" <<EOF
KUBECTL_VERSION=${KUBECTL_VERSION}
KUSTOMIZE_VERSION=${KUSTOMIZE_VERSION}
KAPP_VERSION=${KAPP_VERSION}
KBLD_VERSION=${KBLD_VERSION}
EOF

apko_yaml="${here}/apko.yaml"
yq -y -i ".environment.KUBECTL_VERSION = \"${KUBECTL_VERSION}\"" "${apko_yaml}"
yq -y -i ".environment.KUSTOMIZE_VERSION = \"${KUSTOMIZE_VERSION}\"" "${apko_yaml}"
yq -y -i ".environment.KAPP_VERSION = \"${KAPP_VERSION}\"" "${apko_yaml}"
yq -y -i ".environment.KBLD_VERSION = \"${KBLD_VERSION}\"" "${apko_yaml}"

tmpdir=$(mktemp -d)
trap 'rm -rf $tmpdir' EXIT

cd "${tmpdir}"
"${here}/download.sh"
sha256sum -- * >"${here}/DIGESTS"
