#!/bin/sh
cat <<EOF
 _     ___
| |   / _ \           kubectl: ${KUBECTL_VERSION}
| | _| (_) |___       kustomize: ${KUSTOMIZE_VERSION}
| |/ /> _ </ __|      kapp: ${KAPP_VERSION}
|   <| (_) \__ \      kbld: ${KBLD_VERSION}
|_|\_\\___/|___/

More info: https://github.com/shelmangroup/distroless-k8s

EOF
exec "${@:-/bin/sh}"
