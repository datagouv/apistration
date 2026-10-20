# Review rules

Some pull requests carry little enough risk to be merged without a
detailed human review, as long as their author vouches for them. The
author stays accountable; their agent acts as a proxy: it reviews the
pull request and checks it against a rule below.

## Author side, usually through an agent

Once the pull request is reviewed (any engine, as many passes as
needed), fixed and pushed, and every condition of a rule holds:

```bash
bin/agentic-review <rule> "<proof>"
# bin/agentic-review docs "3 files, all under site/docs/; CI green; no conflict"
```

It posts a green `agentic-review/<rule>` status on the head commit, under
the author's name, with the proof as description (140 characters at
most), and sets the `auto-mergeable:<rule>` label. Any later push leaves
the new head without status: check the rule again and rerun it. Running
it engages the author like an approval would.

If a condition does not hold, do not run it: the pull request goes
through the normal review. Agents never merge.

## Merger side

With the label set and a green `agentic-review/<rule>` status on the
head commit, approve and merge without reading the change in detail.
Without the status, or in doubt, remove the label: normal review.

## Rules

### `auto-mergeable:docs` — internal technical documentation

- every file of the pull request, renames included, lives under
  `docs/`, `siade/docs/` or `site/docs/`: internal Markdown, not served
  to users;
- the CI is green and there is no conflict with `develop`.

Out of the rule, whatever the change: `commons/endpoints/`
(documentation displayed on the site, mixed with parameters and
versions), `commons/swagger/`, and any other `*.md` (README, CLAUDE.md,
REVIEW.md, skills).
