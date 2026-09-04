#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat >&2 <<USAGE
Usage: $(basename "$0") [-p port] <name> [branch]

Creates the git worktree worktrees/<name> and generates dotenv files in siade/
and site/ so the worktree gets its own Postgres databases (suffix derived from
the name) and its own server ports.

<name> is either a Linear ticket (API-7345) or an ad hoc slug for work that
has no ticket (cnav-nir).

Ports default to 1NNNN for siade and 2NNNN for site, NNNN being the ticket
number zero-padded to four digits (API-7345 -> 17345 / 27345) or, for an
ad hoc name, four digits derived from a hash of the name. With -p, siade
listens on <port> and site on <port> + 1.

Branch resolution, in order:
  1. [branch] when given
  2. an existing local or remote branch whose name contains <name>
     (Linear-generated branches such as feature/api-7345-rotation-...)
  3. a new feature/<name> branch created from develop
USAGE
  exit 1
}

PORT=""
while getopts "p:h" opt; do
  case "$opt" in
    p) PORT="$OPTARG" ;;
    *) usage ;;
  esac
done
shift $((OPTIND - 1))

[ $# -ge 1 ] && [ $# -le 2 ] || usage

NAME="$(echo "$1" | tr '[:upper:]' '[:lower:]')"
BRANCH="${2:-}"

if [[ ! "$NAME" =~ ^[a-z0-9][a-z0-9-]*$ ]]; then
  echo "Error: '$1' must be a Linear ticket (API-7345) or a slug (cnav-nir)" >&2
  exit 1
fi

if [[ "$NAME" =~ ^[a-z]+-([0-9]+)$ ]]; then
  PORT_SEED="${BASH_REMATCH[1]}"
else
  PORT_SEED="$(printf '%s' "$NAME" | cksum | cut -d' ' -f1)"
fi

if [ -n "$PORT" ] && { [[ ! "$PORT" =~ ^[0-9]+$ ]] || [ "$PORT" -lt 1024 ] || [ "$PORT" -gt 65534 ]; }; then
  echo "Error: invalid port '$PORT' (expected 1024-65534)" >&2
  exit 1
fi

if [ -n "$PORT" ]; then
  SIADE_PORT="$PORT"
  SITE_PORT="$((PORT + 1))"
else
  SIADE_PORT="$((10000 + PORT_SEED % 10000))"
  SITE_PORT="$((20000 + PORT_SEED % 10000))"
fi

PRIMARY_ROOT="$(dirname "$(git rev-parse --path-format=absolute --git-common-dir)")"
WORKTREES_DIR="$PRIMARY_ROOT/worktrees"
WORKTREE_PATH="$WORKTREES_DIR/$NAME"
SLUG="${NAME//-/_}"

if [ -e "$WORKTREE_PATH" ]; then
  echo "Error: $WORKTREE_PATH already exists" >&2
  exit 1
fi

for port in "$SIADE_PORT" "$SITE_PORT"; do
  if lsof -nP -iTCP:"$port" -sTCP:LISTEN >/dev/null 2>&1; then
    echo "Error: port $port is already in use, pick another one with -p" >&2
    exit 1
  fi
done

git -C "$PRIMARY_ROOT" fetch --quiet origin || echo "Warning: could not fetch origin, using local refs only" >&2

find_branch_by_name() {
  git -C "$PRIMARY_ROOT" for-each-ref --format='%(refname:short)' refs/heads refs/remotes/origin \
    | grep -v '/HEAD$' \
    | grep -i -- "$NAME" \
    | sed 's#^origin/##' \
    | sort -u \
    | head -n 1
}

if [ -z "$BRANCH" ]; then
  BRANCH="$(find_branch_by_name || true)"
fi

if [ -n "$BRANCH" ] && git -C "$PRIMARY_ROOT" show-ref --verify --quiet "refs/heads/$BRANCH"; then
  echo "Using local branch $BRANCH"
  git -C "$PRIMARY_ROOT" worktree add "$WORKTREE_PATH" "$BRANCH"
elif [ -n "$BRANCH" ] && git -C "$PRIMARY_ROOT" show-ref --verify --quiet "refs/remotes/origin/$BRANCH"; then
  echo "Tracking remote branch origin/$BRANCH"
  git -C "$PRIMARY_ROOT" worktree add --track -b "$BRANCH" "$WORKTREE_PATH" "origin/$BRANCH"
else
  BRANCH="${BRANCH:-feature/$NAME}"
  echo "No branch found for $NAME, creating $BRANCH from develop"
  git -C "$PRIMARY_ROOT" worktree add -b "$BRANCH" "$WORKTREE_PATH" develop
fi

for local_file in .sentry_token .metabase .metabase_token .hyperping_token; do
  [ -e "$PRIMARY_ROOT/$local_file" ] && cp "$PRIMARY_ROOT/$local_file" "$WORKTREE_PATH/$local_file"
done

write_env() {
  local app="$1"
  local db_prefix="$2"
  local port="$3"
  local dir="$WORKTREE_PATH/$app"

  cat > "$dir/.env.local" <<ENV
DATABASE_NAME_DEVELOPMENT=${db_prefix}_development_${SLUG}
DATABASE_NAME_TEST=${db_prefix}_test_${SLUG}
PORT=${port}
ENV
  cat > "$dir/.env.test.local" <<ENV
DATABASE_NAME_TEST=${db_prefix}_test_${SLUG}
ENV
  echo "Wrote $dir/.env.local and $dir/.env.test.local"
}

write_env siade siade "$SIADE_PORT"
write_env site admin_apientreprise "$SITE_PORT"

setup_app() {
  local app="$1"

  echo
  echo "==> Bootstrapping $app"
  (cd "$WORKTREE_PATH/$app" && (bundle check >/dev/null || bundle install) && bin/rails db:prepare)
}

setup_app siade
setup_app site

echo
echo "Worktree ready: $WORKTREE_PATH"
echo "Branch:         $BRANCH"
echo "DB suffix:      $SLUG"
echo "siade:          http://localhost:${SIADE_PORT}"
echo "site:           http://entreprise.api.localtest.me:${SITE_PORT}"
