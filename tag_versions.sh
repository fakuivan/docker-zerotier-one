#!/usr/bin/env bash
set -euo pipefail

IMAGE_NAME="$1"

VERSION="$(
    docker run --rm "$IMAGE_NAME":latest \
        rpm -q --queryformat '%{VERSION}' zerotier-one)"
VERSION_REL="$(
    docker run --rm "$IMAGE_NAME":latest \
        rpm -q --queryformat '%{VERSION}-%{RELEASE}' zerotier-one)"

docker tag "$IMAGE_NAME":latest "$IMAGE_NAME":"$VERSION"
docker tag "$IMAGE_NAME":latest "$IMAGE_NAME":"$VERSION_REL"
