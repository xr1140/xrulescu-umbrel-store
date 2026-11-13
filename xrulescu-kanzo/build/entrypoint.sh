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

# A local safety copy before a start where the board changed. Backups live in
# the data folder, rotate to the newest five, and are skipped when the database
# has not changed since the newest one.
backups="$KANZO_HOME/backups"
mkdir -p "$backups"
db="$KANZO_HOME/kanzo.db"
if [ -f "$db" ]; then
	latest=$(ls -1t "$backups"/kanzo-*.tar.gz 2>/dev/null | head -n 1)
	if [ -z "$latest" ] || [ "$db" -nt "$latest" ]; then
		stamp=$(date +%Y%m%d-%H%M%S)
		archive="$backups/kanzo-$stamp-$$.tar.gz"
		if tar -czf "$archive" -C "$KANZO_HOME" --exclude=backups --exclude=kanzo.lock .; then
			echo "kanzo: backup at $archive"
			ls -1t "$backups"/kanzo-*.tar.gz 2>/dev/null | tail -n +6 | while IFS= read -r old; do
				rm -f "$old"
			done
		else
			echo "kanzo: cannot write a backup; starting anyway" >&2
			rm -f "$archive"
		fi
	fi
fi

exec kanzo --no-open "$@"
