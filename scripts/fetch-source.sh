#!/usr/bin/env bash
# Downloads the pinned Kanzo source tarball and verifies its checksum.
set -euo pipefail

cd "$(dirname "$0")/.."
# shellcheck disable=SC1091
source ./upstream.env

mkdir -p .build
echo "Downloading Kanzo ${KANZO_VERSION}..."
curl -fsSL "$KANZO_SOURCE_URL" -o .build/source.tar.gz
echo "${KANZO_SOURCE_SHA256}  .build/source.tar.gz" | sha256sum -c -

rm -rf .build/src
mkdir -p .build/src
tar -xzf .build/source.tar.gz -C .build/src

test -f ".build/src/kanzo-${KANZO_VERSION}/Cargo.toml" || {
	echo "Unexpected tarball layout: .build/src/kanzo-${KANZO_VERSION}/Cargo.toml is missing" >&2
	exit 1
}
echo "Source ready in .build/src/kanzo-${KANZO_VERSION}"
