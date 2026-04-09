## commons

Shared assets / code / data used by more than one of the sibling apps in this
repository (`site/`, `siade/`, `mocks/`).

### How it gets into each app

Each app is deployed in isolation: only its own subdirectory (e.g. `site/`) is
copied to the server. To make `commons/` files available inside an app at
deploy time, two things are wired up:

1. **Local development:** each file a consumer app expects from `commons/` is
   committed as a symlink at the path the app code reads. App code references
   the in-app path directly; the symlink resolves to the shared file in dev.

2. **Deployment:** each consumer app contains an `.expand` file at its root
   listing the commons files that must be materialized inside the deploy
   build. Each non-comment line has the form `source:destination` where
   `source` is a path relative to the repository root and `destination` is a
   path relative to the app's build directory. If `:destination` is omitted,
   `source` is reused as the destination. The deployment script (see
   `very_ansible/roles/rails_app/templates/deploy_script.sh.j2`) replaces each
   destination path (which is a symlink on disk) with a real copy of the
   source taken from the repository root.

### Adding a new shared file

1. Put it under `commons/` (or anywhere at the repo root).
2. In each consuming app, commit a symlink at the path the code reads.
3. Add a `source:destination` line in that app's `.expand` file.
