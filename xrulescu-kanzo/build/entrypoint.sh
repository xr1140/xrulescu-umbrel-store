#!/bin/sh
# Kanzo has no environment variables for its config, so the first start writes
# config.toml itself. Later starts leave it alone: the user may edit it.
set -eu

: "${KANZO_HOME:=/data}"
export KANZO_HOME

mkdir -p "$KANZO_HOME"

if [ ! -f "$KANZO_HOME/config.toml" ]; then
	# listen = 0.0.0.0 is what lets Umbrel's proxy reach the board. The port
	# stays at Kanzo's default; Umbrel publishes its own port in front of it.
	tmp="$KANZO_HOME/config.toml.part"
	cat > "$tmp" <<'EOF'
# Kanzo settings, written on the first start of the Umbrel package.

# Port inside the container. Umbrel publishes the app on its own port.
port = 4242

# The board has to listen on all interfaces for Umbrel's proxy to reach it.
listen = "0.0.0.0"

# MCP over HTTP at /mcp, reachable through Umbrel's proxy.
mcp_http = true
EOF
	mv "$tmp" "$KANZO_HOME/config.toml"
fi

exec kanzo --no-open "$@"
