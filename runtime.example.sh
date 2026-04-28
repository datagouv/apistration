#!/bin/bash
# =============================================================================
# runtime.example.sh — Template for ~/.agent-vm/runtime.sh
# =============================================================================
#
# This file runs inside every agent-vm on each start, BEFORE the per-project
# .agent-vm.runtime.sh script. It is the right place for things tied to *you*
# (SSH keys, git identity, GitHub auth, Claude config) rather than to the
# project (those go in the repo's .agent-vm.runtime.sh).
#
# Setup:
#   cp runtime.example.sh ~/.agent-vm/runtime.sh
#   chmod +x ~/.agent-vm/runtime.sh
#   # Edit with your own values, then uncomment the sections you need.
#
# This file is a TEMPLATE: it must stay free of secrets. Keep your real
# ~/.agent-vm/runtime.sh out of any repository.


# =============================================================================
# 1. SSH authentication for GitHub
# =============================================================================
#
# Embed your SSH private key (base64-encoded) so the VM can push, pull and
# clone over SSH. Without this the VM has no way to talk to GitHub privately.
#
#   To encode your key on the host:
#     cat ~/.ssh/id_ed25519 | base64
#
# Paste the output below.

# SSH_KEY_B64="<your-base64-encoded-private-key>"
# mkdir -p ~/.ssh && chmod 700 ~/.ssh
# echo "$SSH_KEY_B64" | base64 -d > ~/.ssh/id_ed25519
# chmod 600 ~/.ssh/id_ed25519
# ssh-keyscan github.com >> ~/.ssh/known_hosts 2>/dev/null


# =============================================================================
# 2. Git identity (required by APIstration's DCO policy)
# =============================================================================
#
# CONTRIBUTING.md requires every commit to carry a `Signed-off-by` trailer
# (Developer Certificate of Origin). `format.signOff = true` makes `git commit`
# add it automatically — no need to remember `-s`.
#
# Recommendation: do NOT run `git commit` from inside the VM if you sign your
# commits with a GPG/SSH key that lives only on the host. Commit from the host
# instead. The VM can still stage, diff, push and review.

# git config --global user.name  "Your Name"
# git config --global user.email "you@example.com"
# git config --global format.signOff true

# Force SSH for all GitHub remotes (avoids HTTPS credential prompts):
# git config --global url."git@github.com:".insteadOf "https://github.com/"


# =============================================================================
# 3. GitHub CLI authentication
# =============================================================================
#
# Required for `gh pr create`, `gh issue comment`, `gh run watch`, etc. from
# inside the VM. The agent will use it heavily.
#
#   Create a fine-grained token: https://github.com/settings/tokens
#   Scopes needed: repo, read:org, workflow
#
# Tip: store the token in `security` (macOS Keychain) on the host and inject
# it via an env var when launching the VM, instead of hard-coding it here.

# echo "<your-github-pat>" | gh auth login --with-token


# =============================================================================
# 4. Claude Code skills shared across all your VMs
# =============================================================================
#
# Skills cloned here are available in every project the VM mounts.
# APIstration ships project-specific skills under .claude/skills/ in the repo
# itself (e.g. edit-endpoint, bump-version, siade-sync-openapi-payloads); those
# are picked up automatically — do NOT duplicate them here.

# mkdir -p ~/.claude/skills
# git clone git@github.com:your-org/claude-skills.git ~/.claude/skills/your-org-skills


# =============================================================================
# 5. MCP servers (user scope)
# =============================================================================
#
# The agent-vm base image already pre-configures Chrome DevTools MCP. Add
# servers you want available in every project. Examples below — uncomment the
# ones you actually use.

# Linear (issue tracker):
# claude mcp add --scope user linear-server npx -y @linear/mcp-server@latest

# Sentry (production errors — siade has bin/sentry/ helpers):
# claude mcp add --scope user sentry npx -y @sentry/mcp-server@latest


# =============================================================================
# 6. APIstration-specific niceties
# =============================================================================

# 6a. Pre-warm bundler caches across VMs. Bundling Ruby 4.0.1 + Rails for
# site/, siade/ and mocks/ takes a while on a fresh VM; mounting a shared
# bundle cache speeds it up significantly. Lima must mount ~/.bundle as RW
# for this to help; see https://lima-vm.io/docs/config/mounts/.
#
# bundle config --global path "$HOME/.bundle/cache"

# 6b. Worktree helper. The repo ships bin/setup_worktree.sh which generates
# isolated .env.local files per worktree (Postgres DBs are namespaced by
# worktree slug). If you create worktrees from inside the VM, alias it:
#
# alias awk-worktree='bash bin/setup_worktree.sh'

# 6c. Default RAILS_ENV. The VM is intentionally non-production; keep it that
# way to avoid hitting production credentials by accident.
#
# export RAILS_ENV=development


# =============================================================================
# 7. Claude Code status line (optional)
# =============================================================================
#
# Show the current git branch at the bottom of the Claude Code UI. Useful when
# you juggle several worktrees inside a single VM.

# cat > /tmp/statusline-patch.json << 'PATCH'
# {"statusLine": {"command": "git branch --show-current 2>/dev/null || echo ''"}}
# PATCH
#
# if [ -f ~/.claude/settings.json ]; then
#   jq -s '.[0] * .[1]' ~/.claude/settings.json /tmp/statusline-patch.json > /tmp/settings-merged.json
#   mv /tmp/settings-merged.json ~/.claude/settings.json
# else
#   mkdir -p ~/.claude
#   cp /tmp/statusline-patch.json ~/.claude/settings.json
# fi
# rm -f /tmp/statusline-patch.json
