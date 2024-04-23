#!/usr/bin/env sh

# Define some constants
SCRIPT="$(readlink -f "$0")"
SCRIPT_NAME="$(basename "$SCRIPT")"
SCRIPT_PATH="$(realpath "$(dirname "$SCRIPT")")"
PROJECT_PATH="$(realpath "$SCRIPT_PATH/..")"
RUBY_VERSION="$(cat "$PROJECT_PATH/.ruby-version" | head -n1)"
TMP_FOLDER="/tmp/siade_staging_data_test_bundler_cache"
CONTAINER_NAME="siade_staging_data_test"

mkdir -p "$TMP_FOLDER" || exit 1

exec docker run \
  --rm \
  --name "$CONTAINER_NAME" \
  -u "$(id -u)" \
  -it \
  -v "$PROJECT_PATH:/app" \
  -v "$TMP_FOLDER:/tmp/gems" \
  ruby:"$RUBY_VERSION" \
  sh -c '\
    cd /app && \
    export BUNDLE_PATH=/tmp/gems && \
    export GEM_HOME=/tmp/gems && \
    export HOME="/tmp/gems" && \
    bundle config set --local path "/tmp/gems" && \
    bundle install && \
    bundle exec rspec \
    '" $*"

