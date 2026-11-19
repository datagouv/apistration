#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat >&2 <<USAGE
Usage: $(basename "$0") <name>

Stops the servers of worktrees/<name>, removes the worktree, deletes its
local branch (the remote branch is kept) and drops every Postgres database
created for it. <name> is the Linear ticket or ad hoc slug given to
setup_worktree.sh.
USAGE
  exit 1
}

[ $# -eq 1 ] || usage

NAME="$(echo "$1" | tr '[:upper:]' '[:lower:]')"

if [[ ! "$NAME" =~ ^[a-z0-9][a-z0-9-]*$ ]]; then
  echo "Error: '$1' must be a Linear ticket (API-7345) or a slug (cnav-nir)" >&2
  exit 1
fi

PRIMARY_ROOT="$(dirname "$(git rev-parse --path-format=absolute --git-common-dir)")"
WORKTREE_PATH="$PRIMARY_ROOT/worktrees/$NAME"
SLUG="${NAME//-/_}"

if [ "$(pwd -P)" = "$WORKTREE_PATH" ] || [[ "$(pwd -P)" == "$WORKTREE_PATH/"* ]]; then
  echo "Error: run this script from outside $WORKTREE_PATH" >&2
  exit 1
fi

listener_pids() {
  local port="$1"

  if command -v lsof >/dev/null; then
    lsof -nP -iTCP:"$port" -sTCP:LISTEN -t 2>/dev/null || true
  elif command -v fuser >/dev/null; then
    fuser -n tcp "$port" 2>/dev/null || true
  else
    echo "Warning: neither lsof nor fuser found, cannot stop the server on port $port" >&2
  fi
}

stop_server() {
  local env_file="$1"
  local port pids pid alive

  [ -f "$env_file" ] || return 0
  port="$(sed -n 's/^PORT=//p' "$env_file")"
  [ -n "$port" ] || return 0
  pids="$(listener_pids "$port")"
  [ -n "$pids" ] || return 0
  echo "$pids" | xargs kill 2>/dev/null || true
  for _ in $(seq 20); do
    alive=""
    for pid in $pids; do
      kill -0 "$pid" 2>/dev/null && alive=1
    done
    [ -n "$alive" ] || break
    sleep 0.5
  done
  if [ -n "$alive" ]; then
    echo "$pids" | xargs kill -KILL 2>/dev/null || true
    echo "Killed server on port $port, still running 10s after SIGTERM" >&2
  else
    echo "Stopped server on port $port"
  fi
}

if [ -d "$WORKTREE_PATH" ]; then
  stop_server "$WORKTREE_PATH/siade/.env.local"
  stop_server "$WORKTREE_PATH/site/.env.local"
  BRANCH="$(git -C "$WORKTREE_PATH" rev-parse --abbrev-ref HEAD)"
  git -C "$PRIMARY_ROOT" worktree remove "$WORKTREE_PATH"
  echo "Removed worktree $WORKTREE_PATH"
  if [ "$BRANCH" != "HEAD" ] && git -C "$PRIMARY_ROOT" branch -d "$BRANCH"; then
    echo "Deleted local branch $BRANCH"
  else
    echo "Warning: local branch $BRANCH kept (unmerged or detached); delete it with git branch -D $BRANCH" >&2
  fi
else
  echo "Warning: $WORKTREE_PATH not found, only dropping databases" >&2
fi

for db_prefix in siade admin_apientreprise; do
  for env in development test; do
    db="${db_prefix}_${env}_${SLUG}"
    if psql -X -Atc "SELECT 1 FROM pg_database WHERE datname = '$db'" postgres | grep -q 1; then
      dropdb --force "$db"
      echo "Dropped database $db"
    fi
  done
done
