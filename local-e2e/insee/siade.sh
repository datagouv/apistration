#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")/../../siade"
export BUNDLE_GEMFILE="$PWD/Gemfile"

command -v redis-server >/dev/null || { echo 'redis-server est requis' >&2; exit 1; }
exec bundle exec ruby ../local-e2e/insee/support/siade.rb
