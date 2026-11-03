# syntax=docker/dockerfile:1
#
# Builds Kanzo from the pinned upstream release tarball and applies the
# reverse-proxy patch. Multi-arch: linux/amd64 and linux/arm64.
#
# The context is the store repository root; run scripts/fetch-source.sh first.

FROM rust:1.98-alpine3.22@sha256:a1796ca6fa216d6727b5f61c69e4c665b120b1a4dcb969639e2f25f1ed309456 AS build

# musl-dev for the static target, patch for the reverse-proxy patch.
RUN apk add --no-cache musl-dev patch

ARG KANZO_VERSION
WORKDIR /src
COPY .build/src/kanzo-${KANZO_VERSION}/ ./
COPY patches/ /patches/
RUN patch -p1 --batch --forward < /patches/0001-trust-reverse-proxy.patch \
	&& cargo build --release --locked

FROM alpine:3.22@sha256:2e0b81d60597f449baa56dc25d355367869d2dca4cd57e866f1e2b52af3eb55f

# git powers the Sync feature (a private git repo as the board's remote).
# curl is deliberately absent: without it Kanzo cannot offer or perform its
# self-update, so updates go through Umbrel's app store instead.
RUN apk add --no-cache git \
	&& addgroup -g 1000 kanzo \
	&& adduser -D -u 1000 -G kanzo -h /data kanzo

COPY --from=build /src/target/release/kanzo /usr/local/bin/kanzo
COPY docker/entrypoint.sh /usr/local/bin/kanzo-entrypoint
RUN chmod 0755 /usr/local/bin/kanzo /usr/local/bin/kanzo-entrypoint

USER 1000:1000
WORKDIR /data
EXPOSE 4242
HEALTHCHECK --interval=30s --timeout=3s --start-period=10s \
	CMD wget -qO- http://127.0.0.1:4242/api/ping >/dev/null || exit 1
ENTRYPOINT ["/usr/local/bin/kanzo-entrypoint"]
