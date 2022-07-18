#!/usr/bin/env bash
set -feu -o pipefail

_melange() {
  podman run --rm -it --privileged -v $(pwd):/github/workspace -w /github/workspace ghcr.io/distroless/melange "$@"
}

# Generate temporary key
test -f melange.rsa || _melange keygen

# Build package
_melange build melange.yaml --arch $(uname -m) -k melange.rsa

# Generate repo index
podman run --rm -it -v $(pwd):/w -w /w/packages -v $(pwd)/packages:/w/packages \
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
    -v $(pwd):/github/workspace -w /github/workspace \
    -v $(pwd)/packages:/github/workspace/packages \
    ghcr.io/distroless/apko build --debug apko.yaml \
    test output.tar -k melange.rsa.pub \
    --build-arch $(uname -m)

# Load image
podman load -i output.tar
