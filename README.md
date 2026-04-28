# APIstration

API and site (APIM + documentation) for [API Entreprise](https://entreprise.api.gouv.fr) and [API Particulier](https://particulier.api.gouv.fr) — French government APIs providing certified data about companies and individuals.

Built and maintained by [DINUM](https://www.numerique.gouv.fr/) (Direction Interministérielle du Numérique).

## Structure

- [`siade/`](siade/) — API application (Système d'Information des API de l'État)
- [`site/`](site/) — Admin / APIM / documentation (formerly [`etalab/admin_api_entreprise`](https://github.com/etalab/admin_api_entreprise))
- [`mocks/`](mocks/) — Test data and sandbox mock server for API Entreprise (v3+) and API Particulier staging environments

## Getting started

- API: see [`siade/README.md`](siade/README.md)
- Site: see [`site/README.md`](site/README.md)
- Mocks: see [`mocks/README.md`](mocks/README.md)

## Scripts

- [`bin/setup_worktree.sh`](bin/setup_worktree.sh) `<path> [branch]` — crée un git worktree et génère des `.env.local` dans `site/` et `siade/` pour isoler les bases Postgres (dev/test) par worktree (via `dotenv-rails`).

## Sandbox via [agent-vm](https://github.com/sylvinus/agent-vm)

Run AI coding agents (Claude Code, OpenCode, Codex) inside an isolated Lima VM. The agent gets full autonomy inside the VM while the host stays clean — no Node, Docker, Postgres or Ruby toolchain to install locally. The repository ships the configuration:

- [`.agent-vm.runtime.sh`](.agent-vm.runtime.sh) — *per-project* script, replayed by agent-vm on every VM start (including each `agent-vm shell`). Installs `postgresql`, `redis-server`, `libgpgme-dev`, `libpq-dev`, `mjml@4` (locally in `site/`), Ruby via `mise` (with `.ruby-version` support enabled), then runs `bundle install`, generates the `siade` GPG signing key, and loads schemas + seeds for `site/` and `siade/`. **Idempotent**: every step is gated either by a marker file in `~/.cache/apistration-agent-vm/` or by a state check (apt packages already installed, services up, Postgres roles existing, gems resolved, etc.). Subsequent runs collapse to a few seconds of no-op checks. Force a full re-bootstrap with `rm -rf ~/.cache/apistration-agent-vm` inside the VM, or `agent-vm rm` from the host to start over with a fresh VM.
- [`runtime.example.sh`](runtime.example.sh) — *per-user* template to copy into `~/.agent-vm/runtime.sh` for your SSH key, git identity (with `format.signOff = true`, required by [`CONTRIBUTING.md`](CONTRIBUTING.md)), `gh auth`, MCP servers, etc. Keep your real copy out of any repository — it may contain secrets.

Host-side setup (once):

```sh
git clone https://github.com/sylvinus/agent-vm.git ~/src/agent-vm
echo "source ~/src/agent-vm/agent-vm.sh" >> ~/.zshrc   # or ~/.bashrc
exec $SHELL
agent-vm setup --disk 30 --memory 8 --cpus 4

cp runtime.example.sh ~/.agent-vm/runtime.sh
chmod +x ~/.agent-vm/runtime.sh
$EDITOR ~/.agent-vm/runtime.sh                          # fill in SSH key, identity, gh token
```

Usage from the repository root:

```sh
agent-vm claude        # Claude Code
agent-vm opencode      # OpenCode
agent-vm codex         # Codex CLI
agent-vm shell         # zsh shell inside the VM
agent-vm --offline claude   # Block outbound internet (code review, audit…)
```

Lima auto-forwards ports: `http://entreprise.api.localtest.me:5000` is reachable from the host browser. The VM persists across sessions; see the [agent-vm README](https://github.com/sylvinus/agent-vm#vm-lifecycle) for `stop` / `rm` / `--rm`.

## Contributing

External contributions are welcome. See [`CONTRIBUTING.md`](CONTRIBUTING.md) for ground rules, workflow, and requirements (signed-off commits, tests, green CI, RGAA accessibility).

## License

[MIT](LICENSE)
