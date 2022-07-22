#!/usr/bin/env bash

ARCH=$(uname -m)
set -feu -o pipefail

ARCH=$(uname -m)

_melange() {
  podman run --rm -it --privileged -v $(pwd):/github/workspace -w /github/workspace ghcr.io/distroless/melange "$@"
}

# Get binaries
./download.sh
sha256sum -c DIGESTS

# Generate temporary key
test -f melange.rsa || _melange keygen

# Build package
_melange build melange.yaml --arch "$ARCH" -k melange.rsa

# Generate repo index
podman run --rm -it -v "$(pwd):/w" -w /w/packages -v "$(pwd)/packages:/w/packages" \
    --entrypoint sh \
    ghcr.io/distroless/melange -c \
        'for d in `find . -type d -mindepth 1`; do \
            ( \
                cd $d && \
                apk index -o APKINDEX.tar.gz *.apk && \
                melange sign-index --signing-key=../../melange.rsa APKINDEX.tar.gz\
            ) \
        done'

# Build image with apko
podman run --rm -it \
    -v "$(pwd):/github/workspace" \
    -v "$(pwd)/packages:/github/workspace/packages" \
    -w /github/workspace \
    -e SOURCE_DATE_EPOCH=0 \
    ghcr.io/distroless/apko build --debug apko.yaml \
      distroless-k8s-dev output.tar -k melange.rsa.pub \
      --build-arch "$ARCH"

# Load image
podman load -i output.tar
