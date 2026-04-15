# Contributing to APIstration

APIstration is an open-source product built and maintained by [DINUM](https://www.numerique.gouv.fr/) (Direction Interministérielle du Numérique) for [API Entreprise](https://entreprise.api.gouv.fr) and [API Particulier](https://particulier.api.gouv.fr). External contributions are welcome.

_Ce projet est bilingue : les issues et pull requests peuvent être rédigées en français, mais l'anglais est privilégié pour le code, les commits, les commentaires et la documentation technique afin de rester accessible au plus grand nombre._

## Ground rules

- **Human accountability.** Do not submit raw, unreviewed AI-generated code. Every change must be read, understood, tested, and validated by a human before a PR is opened. By submitting a pull request, you certify that you fully understand the proposed code and can explain and defend it in review without relying on an AI assistant. AI tooling is allowed; AI slop is not.
- **One feature, one PR.** Keep pull requests focused on a single concern. Split unrelated changes into separate PRs so reviews stay manageable.
- **Signed-off commits.** All commits must carry a `Signed-off-by` trailer ([Developer Certificate of Origin](https://developercertificate.org/)). Use `git commit -s` (or configure it globally). PRs with unsigned commits will not be merged.
- **Tests are required.** Every feature or bug fix must ship with tests that cover the new behaviour. TDD is recommended. Tests must be meaningful, not just present.
- **Green CI before review.** Do not request a review until the full CI pipeline is green on your PR. Reviewers' time is a shared resource — run the checks locally (tests, lint, format) before pushing.
- **Accessibility (RGAA).** Any change to the `site/` UI must comply with the French [Référentiel Général d'Amélioration de l'Accessibilité](https://accessibilite.numerique.gouv.fr/). Verify keyboard navigation, screen reader labels, contrast, and focus states before opening a PR.

## Workflow

1. Open (or comment on) an issue describing the problem or feature before starting significant work.
2. Fork the repository and create a branch from the default branch.
3. Make your changes with tests. Keep commits atomic; commit messages should explain the _why_, not just the _what_.
4. Sign off every commit (`git commit -s`).
5. Push and open a pull request. Fill the description with context, rationale, and any manual test steps.
6. Wait for CI to be fully green, then request a maintainer review.
7. Address review feedback with new commits (avoid force-push during review so reviewers can see incremental changes).
8. A maintainer merges once approved.

## Project layout

- [`siade/`](siade/) — API application. See [`siade/README.md`](siade/README.md) for setup, tests, and linting.
- [`site/`](site/) — Admin / APIM / documentation. See [`site/README.md`](site/README.md).
- [`mocks/`](mocks/) — Test data and sandbox mock server. See [`mocks/README.md`](mocks/README.md).

Each sub-project documents its own stack, commands, and conventions. Follow them.

## Reporting bugs and security issues

- **Bugs and feature requests:** open a [GitHub issue](https://github.com/datagouv/apistration/issues). Maintainers are reachable through issues — no private channel.
- **Security vulnerabilities:** please do **not** open a public issue for a suspected vulnerability. Contact the maintainers privately first so the issue can be triaged and fixed before disclosure.

## License

By contributing, you agree that your contributions will be licensed under the [MIT License](LICENSE) covering the project.
