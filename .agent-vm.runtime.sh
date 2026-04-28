#!/usr/bin/env zsh
# Runs inside the agent-vm Lima VM each time it starts (and on `agent-vm shell`).
# Bootstraps everything required to run site/, siade/ and mocks/.
#
# IMPORTANT: agent-vm pipes this file into `zsh -l` (the shebang is ignored).
# Keep it zsh-compatible — no BASH_SOURCE, no bash-isms.
#
# The agent-vm base image already provides: git, curl, build-essential,
# Node.js 24, mise, Docker, headless Chromium, ripgrep, gh.
# We only add what the three Ruby apps need on top.
#
# Each step is idempotent and gated so re-runs are fast. Force a full re-run
# by deleting the relevant marker in $STATE_DIR (or all of $STATE_DIR).

set -eo pipefail

REPO_ROOT="$PWD"
STATE_DIR="$HOME/.cache/apistration-agent-vm"
mkdir -p "$STATE_DIR"

log()  { printf '\n\033[1;34m==> %s\033[0m\n' "$*"; }
skip() { printf '    \033[2m· %s (already done)\033[0m\n' "$*"; }
done_marker() { touch "$STATE_DIR/$1"; }
has_marker()  { [ -f "$STATE_DIR/$1" ]; }

# -- 1. system packages -------------------------------------------------------
if has_marker apt.done; then
  skip "system packages"
else
  log "Installing system packages (postgres, redis, gpgme, libpq, …)"
  sudo DEBIAN_FRONTEND=noninteractive apt-get update -y
  sudo DEBIAN_FRONTEND=noninteractive apt-get install -y \
    postgresql postgresql-contrib \
    redis-server \
    libpq-dev \
    libgpgme-dev libgpgme11t64 \
    gnupg2 \
    libyaml-dev libffi-dev libreadline-dev zlib1g-dev libssl-dev \
    libxml2-dev libxslt1-dev \
    pkg-config
  done_marker apt.done
fi

# -- 2. services --------------------------------------------------------------
log "Ensuring postgres + redis are running"
sudo service postgresql status >/dev/null 2>&1 || sudo service postgresql start
sudo service redis-server status >/dev/null 2>&1 || sudo service redis-server start

# -- 3. pg_hba auth -----------------------------------------------------------
if has_marker pg-hba.done; then
  skip "pg_hba (already trust)"
else
  log "Relaxing local pg_hba auth (dev VM only)"
  PG_HBA="$(sudo -u postgres psql -tAc 'SHOW hba_file;')"
  sudo sed -i \
    -e 's/^\(local\s\+all\s\+all\s\+\).*/\1trust/' \
    -e 's/^\(host\s\+all\s\+all\s\+127\.0\.0\.1\/32\s\+\).*/\1trust/' \
    -e 's/^\(host\s\+all\s\+all\s\+::1\/128\s\+\).*/\1trust/' \
    "$PG_HBA"
  sudo service postgresql restart
  done_marker pg-hba.done
fi

# -- 4. DB roles + databases --------------------------------------------------
if sudo -u postgres psql -tAc "SELECT 1 FROM pg_roles WHERE rolname='siade'" 2>/dev/null | grep -q 1 \
   && sudo -u postgres psql -tAc "SELECT 1 FROM pg_roles WHERE rolname='admin_apientreprise'" 2>/dev/null | grep -q 1; then
  skip "Postgres roles + databases"
else
  log "Creating Postgres roles and databases"
  sudo -u postgres psql -v ON_ERROR_STOP=0 -f "$REPO_ROOT/site/postgresql_setup.txt"     || true
  sudo -u postgres psql -v ON_ERROR_STOP=0 -f "$REPO_ROOT/siade/db/postgresql_setup.txt" || true
fi

# -- 5. mjml ------------------------------------------------------------------
# mjml-rails (in site/) requires mjml v4 and looks for it in the project's
# node_modules, not on $PATH. Pin to v4 explicitly — `mjml` (latest) ships v5+
# which the gem rejects with "Couldn't find the MJML 4. binary".
if [ -x "$REPO_ROOT/site/node_modules/.bin/mjml" ] \
   && "$REPO_ROOT/site/node_modules/.bin/mjml" --version 2>/dev/null | grep -q '^mjml-core: 4\.'; then
  skip "mjml v4 (site/node_modules)"
else
  log "Installing mjml@4 locally in site/"
  ( cd "$REPO_ROOT/site" && npm install --no-save 'mjml@^4' )
fi

# -- 6. Ruby + bundle per app -------------------------------------------------
# mise ignores .ruby-version unless idiomatic_version_file is enabled for ruby.
# Without this, `mise install` finds nothing and `mise exec -- bundle` fails.
if ! mise settings get idiomatic_version_file_enable_tools 2>/dev/null | grep -q ruby; then
  log "Enabling .ruby-version support in mise"
  mise settings add idiomatic_version_file_enable_tools ruby
fi

log "Ensuring Ruby and gems for site/ siade/ mocks/"
for app in site siade mocks; do
  ( cd "$REPO_ROOT/$app"
    mise install
    if ! mise exec -- which bundle >/dev/null 2>&1; then
      log "  → installing bundler ($app)"
      mise exec -- gem install --no-document --conservative bundler
    fi
    if mise exec -- bundle check >/dev/null 2>&1; then
      skip "$app gems"
    else
      log "  → bundle install ($app)"
      mise exec -- bundle install
    fi
  )
done

# -- 7. siade GPG keys + schema ----------------------------------------------
# Skip siade/bin/install.sh: it re-tries to install gpgme via brew/apt (noise +
# permission errors) and runs psql without -U postgres. Reproduce only the
# parts that aren't covered elsewhere.
if has_marker siade-bootstrap.done; then
  skip "siade GPG + schema"
else
  log "Bootstrapping siade GPG keys + schema"
  ( cd "$REPO_ROOT/siade"
    find config/gpg_public_keys_for_data_encryption -type f -name '*.asc' -print0 \
      | xargs -0 -r gpg2 --import 2>&1 | grep -v '^gpg: key .* not changed$' || true

    signer_email=$(mise exec -- ruby -ryaml -e 'print YAML.load_file("config/encrypt_data_signer_data.yml")["shared"]["signer_email"]')
    signer_pass=$(mise exec -- ruby -ryaml -e 'print YAML.load_file("config/encrypt_data_signer_data.yml")["shared"]["signer_passphrase"]')

    if ! gpg2 --list-keys 2>/dev/null | grep -q "$signer_email"; then
      mkdir -p ~/.gnupg
      grep -q use-agent              ~/.gnupg/gpg.conf       2>/dev/null || echo use-agent              >> ~/.gnupg/gpg.conf
      grep -q "pinentry-mode loopback" ~/.gnupg/gpg.conf     2>/dev/null || echo pinentry-mode loopback >> ~/.gnupg/gpg.conf
      grep -q allow-loopback-pinentry ~/.gnupg/gpg-agent.conf 2>/dev/null || echo allow-loopback-pinentry >> ~/.gnupg/gpg-agent.conf
      echo RELOADAGENT | gpg-connect-agent
      printf 'Key-Type: DSA\nKey-Length: 1024\nSubkey-Type: ELG-E\nSubkey-Length: 1024\nName-Real: Test User\nName-Email: %s\nExpire-Date: 0\nPassphrase: %s\n%%commit\n' \
        "$signer_email" "$signer_pass" | gpg2 --batch --gen-key
    fi

    mise exec -- bin/rails db:schema:load RAILS_ENV=test
    mise exec -- bin/rails db:schema:load RAILS_ENV=development
  ) && done_marker siade-bootstrap.done \
    || echo "siade bootstrap returned non-zero (delete $STATE_DIR/siade-bootstrap.done to retry)"
fi

# -- 8. site schema + seeds ---------------------------------------------------
if has_marker site-bootstrap.done; then
  skip "site schema + seeds"
else
  log "Loading site/ schema (test + development) and seeds"
  ( cd "$REPO_ROOT/site"
    mise exec -- bin/rails db:schema:load RAILS_ENV=test
    mise exec -- bin/rails db:schema:load RAILS_ENV=development
    mise exec -- bin/rails db:seed:replant
  ) && done_marker site-bootstrap.done \
    || echo "site bootstrap returned non-zero (delete $STATE_DIR/site-bootstrap.done to retry)"
fi

log "Ready. Servers:"
cat <<'EOF'
  site   : cd site   && bin/local.sh           (http://entreprise.api.localtest.me:5000)
  siade  : cd siade  && bin/rails s -p 3000
  mocks  : cd mocks  && bundle exec rspec      (data-only repo, no server)

  Force a full re-bootstrap: rm -rf ~/.cache/apistration-agent-vm
EOF
