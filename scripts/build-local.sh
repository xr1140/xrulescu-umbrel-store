#!/usr/bin/env bash
# Builds the image for this machine's architecture, so it can be run and tested.
set -euo pipefail

cd "$(dirname "$0")/.."
# shellcheck disable=SC1091
source ./upstream.env

bash scripts/fetch-source.sh

PLATFORM="${PLATFORM:-linux/amd64}"
TAG="${TAG:-kanzo-umbrel:dev}"

docker buildx build --load \
	--platform "$PLATFORM" \
	--build-arg "KANZO_VERSION=$KANZO_VERSION" \
	-f docker/Dockerfile \
	-t "$TAG" \
	.

cat <<EOF

Built $TAG for $PLATFORM.

Try it:
  docker run --rm -p 4290:4242 -v kanzo-dev:/data $TAG
  curl -H 'Host: umbrel.local:4290' http://127.0.0.1:4290/api/ping

Then open http://127.0.0.1:4290
EOF
