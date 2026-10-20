# Review rules

Some pull requests carry little enough risk that the merger does not need
to read them in detail: checking a few mechanical conditions is enough.
Each rule below names those conditions and the label that declares it.

The author (human or agent) sets the rule's label and names the rule in
the pull request description. The label is a claim, not a proof: whoever
merges checks the rule's conditions, approves and merges. If a condition
does not hold, they remove the label and the pull request goes through
the normal review.

Agents never merge: they set the label and leave the merge to a human.

## `auto-mergeable:docs` — internal technical documentation

Every file of the pull request lives under `docs/`, `siade/docs/` or
`site/docs/`: internal Markdown, not served to users.

Out of the rule, whatever the change: `commons/endpoints/` (documentation
displayed on the site, mixed with parameters and versions),
`commons/swagger/`, and any other `*.md` (README, CLAUDE.md, REVIEW.md,
skills).

Before merging, check on the pull request:

- the Files changed tab lists only paths under the three folders above,
  renames included;
- the CI is green;
- there is no conflict with `develop`.
