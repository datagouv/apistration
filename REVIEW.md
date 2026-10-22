# Review rules

Some pull requests carry little enough risk to be merged without a
detailed human review, as long as their author vouches for them. The
author stays accountable; their agent acts as a proxy: it reviews the
pull request and checks it against a rule below.

## Author side, usually through an agent

Once the pull request is reviewed (any engine, as many passes as
needed), fixed and pushed, and every condition of a rule holds:

```bash
bin/vouch-auto-mergeable <rule> "<proof>"
# bin/vouch-auto-mergeable docs "3 files, all under site/docs/; CI green; no conflict"
```

It posts a green `auto-mergeable/<rule>` status on the head commit, under
the author's name, with the proof as description (140 characters at
most), and sets the `auto-mergeable:<rule>` label. Any later push leaves
the new head without status: check the rule again and rerun it. Running
it engages the author like an approval would.

If a condition does not hold, do not run it: the pull request goes
through the normal review.

## Merging

With the label set, a green `auto-mergeable/<rule>` status on the head
commit and a green CI, the pull request is merged without reading the
change in detail, either:

- by someone else, who approves and merges;
- by its author or their agent, without approval, through the bypass
  of the `develop` ruleset granted to the `api` team:

  ```bash
  gh pr merge <number> --merge --admin
  ```

`--admin` bypasses the whole ruleset, failing CI included: use it only
on a pull request carrying the label, the status on its current head
and a green CI, never to merge anything else. Without the status, or in
doubt, remove the label: normal review.

## Zones out of every code rule

The `fix-*` and `refactor` rules cover code, where a mistake costs more
than in documentation. None of them applies, whatever the size, to a
pull request that creates or modifies any file or code relevant to:

- authentication and security: JWT and tokens, scopes and
  authorizations (`commons/data/authorizations.yml`), access control,
  IP ranges, rate limiting, delegations, passwords, credentials,
  certificates;
- existing interfaces: payloads and serializers, routes,
  `commons/swagger/`, `commons/endpoints/`, `siade/config/errors.yml`,
  `clients/`;
- data: migrations and schemas, data stored or served as is
  (`commons/data/`, dictionaries);
- what specs do not protect: dependencies (`Gemfile*`, `package*.json`),
  CI (`.github/`), on which every rule relies to be green, and
  configuration under `config/`, except what a rule names;
- `REVIEW.md` and `bin/vouch-auto-mergeable` themselves.

A log statement that changes no behaviour is the only line accepted in
these files, under `fix-observability`. Sizes count added plus deleted
lines outside specs:

```bash
git diff --shortstat origin/develop...HEAD -- . ':!*/spec/*'
```

## Rules

### `auto-mergeable:docs` — internal technical documentation

- every file of the pull request, renames included, lives under
  `docs/`, `siade/docs/` or `site/docs/`: internal Markdown, not served
  to users;
- the CI is green where it runs (none runs for `docs/` at the root)
  and there is no conflict with `develop`.

Out of the rule, whatever the change: `commons/endpoints/`
(documentation displayed on the site, mixed with parameters and
versions), `commons/swagger/`, and any other `*.md` (README, CLAUDE.md,
REVIEW.md, skills).

### `auto-mergeable:fix-observability` — logs and monitoring

- every changed line outside specs is a log, Sentry or metrics
  statement (message, level, context, fingerprint), the list of
  filtered parameters (`config/initializers/filter_parameter_logging.rb`),
  code of `MonitoringService` or of the Sentry tooling under
  `bin/sentry/`: such lines are accepted in any file, excluded zones
  included;
- the control flow does not change: no new or moved `return`, `rescue`
  or condition, no method signature change; a new statement only reads
  values already at hand and cannot raise where the code did not;
- filtering only grows: no parameter leaves the filtered list, and no
  newly logged value carries personal data or a secret;
- nothing visible to API or site users changes, which is why no spec
  is required;
- the CI is green and there is no conflict with `develop`.

Out of the rule: pings and the status page (`config/pings.yml`, ping
drivers), shown to users, and alerting thresholds.

```bash
bin/vouch-auto-mergeable fix-observability "1 file, log line only (path instead of fullpath), filters more, no flow change; CI green; no conflict"
```
