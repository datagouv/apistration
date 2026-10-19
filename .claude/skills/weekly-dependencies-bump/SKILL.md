---
name: weekly-dependencies-bump
description: Triage, validate and merge the open Dependabot pull requests on datagouv/apistration. Handles the green minor/patch bumps end to end, flags major bumps for a human decision — including the ones hiding in a lockfile behind a dev-only title — and repairs the rubocop bumps whose new cops break the Lint job. Triggers — "check les PRs dependabot", "merge les dependabot", "bump hebdo des dépendances", "weekly dependencies", "les PRs de mise à jour de gems", "rubocop bump rouge".
---

# Weekly Dependencies Bump

Routine pass over the open Dependabot PRs. The goal is zero open Dependabot PR
at the end, or an explicit question to the user for the ones that cannot be
decided alone.

## Decision rules

1. **Green + no major bump** → approve and merge, no questions asked.
2. **Green + major bump** → read the changelog and the diff. Merge only if the
   breaking changes provably do not touch this codebase; otherwise ask.
3. **Red on Lint only, rubocop bump** → fix it (see below), then merge.
4. **Red on anything else** → investigate, and ask before merging.
5. **Lifts a version ceiling in a `Gemfile`** → never merge on your own.
   Dependabot proposes lifting an existing pin (`gem 'json', '< 3'` → `'< 4'`)
   as soon as a new major exists. That pin was someone's decision; only a human
   undoes it. Raising a floor or an exact pin inside the same major
   (`'~> 4.20'` → `'~> 4.22'`, `'1.1.1'` → `'1.1.2'`) is not a lifted pin: it
   is how Dependabot writes any bump of a constrained gem, so rules 1 to 4
   apply as usual.

A grouped PR (`bump the development-dependencies group ... with N updates`)
holds several gems: read the body and apply the rules to *every* gem in it.

"Major bump" is judged on the **lockfile diff**, not on the title or the body.
A development-only group can carry a production gem to a major through a
transitive requirement, and the PR still calls itself `deps-dev`:

```bash
gh pr diff <pr> | grep -E "^[+-] +[a-z0-9_-]+ \([0-9]" | sort -k2
gh pr diff <pr> | grep -E "^[+-]gem |^\+\+\+ .*Gemfile$"   # empty = no pin touched
```

`gh pr diff` takes no pathspec, hence the grep. The second output shows the
`Gemfile` lines Dependabot rewrote: a `<` ceiling or an exact pin moving to a
new major is rule 5, a floor raised inside the same major is not.

A grouped PR with a single major among minor bumps is not left blocked as a
whole: carry the other gems into a PR of your own (see the last section,
`bundle update --conservative` on those gems only, with the same `Gemfile`
constraints Dependabot wrote), and hand the major to a dedicated session
(`/start`) that checks it against the codebase and opens its own bump PR.

## Triage

```bash
gh pr list --author "app/dependabot" --limit 50 \
  --json number,title --jq '.[] | "\(.number)\t\(.title)"'

for pr in <numbers>; do
  echo "=== $pr ==="
  gh pr view $pr --json title,mergeable,mergeStateStatus,statusCheckRollup \
    --jq '"\(.title)\n\(.mergeable) \(.mergeStateStatus)\n" +
          ([.statusCheckRollup[] | "\(.name // .context): \(.conclusion // .state)"] | join("\n"))'
done
```

`mergeStateStatus: BLOCKED` on a fully green PR just means the review is
missing — approving unblocks it. `SKIPPED` deploy jobs are normal on a branch.

For a grouped or major bump, read the changelog Dependabot embeds in the body:

```bash
gh pr view <pr> --json body --jq .body
```

## Merging

```bash
gh pr review <pr> --approve && gh pr merge <pr> --merge
```

Merge commits, not squash — that is the repo's history style. Verify
afterwards, `gh pr merge` stays silent on success:

```bash
gh pr view <pr> --json number,state,mergedAt
```

`gh pr list` lags a few seconds behind a merge and can still show the PR:
trust `gh pr view`.

Merging one PR makes Dependabot rebase the others touching the same
lockfile: their checks restart and `mergeable` reads `UNKNOWN` for a while.
Wait for `gh pr checks` to settle before approving.

## good_job bumps

good_job ships its schema changes as generated migrations, not inside the
gem. Every good_job bump, even a minor one, goes with
`bin/rails g good_job:update` in `site/`, in a commit of its own after the
bump (precedents: #498 for 4.20, #523 for 4.22). A Dependabot PR bumping
good_job is therefore carried into a PR of your own rather than merged as is.
`create` lines in the generator output are the new migrations; none means the
bump needs nothing.

Run the migration, then rollback and migrate again. The schema dump also
rewrites the `consumption_summary` view (its name is built from `Rails.env`,
and the local PostgreSQL renders the `ANY (ARRAY[...])` casts differently):
commit only the hunks of the new tables and the schema version.

## Repairing a rubocop bump

A rubocop minor release ships new cops; the pre-existing code violates them and
the `Lint` job turns red. The fix is mechanical, but it edits application code,
so it needs a real checkout and a local verification — never push a blind
autocorrect.

There is one rubocop PR per app (`/siade` and `/site`), each with its own
`Gemfile`. Handle them one at a time.

Read the failure first, to confirm it is only new-cop noise:

```bash
branch=$(gh pr view <pr> --json headRefName --jq .headRefName)
run=$(gh run list --branch "$branch" --limit 1 --json databaseId --jq '.[0].databaseId')
gh run view "$run" --log-failed | grep -iE "offense|\.rb:[0-9]+" | head -40
```

Then work in a throwaway worktree, so the main checkout keeps its branch:

```bash
git fetch origin
git worktree add "$SCRATCHPAD/rubocop-siade" dependabot/bundler/siade/rubocop-xxxxxxxx
cd "$SCRATCHPAD/rubocop-siade/siade"   # or .../site for the site PR
bundle install
bundle exec rubocop -a
```

`-a` (safe autocorrect) is the first attempt. Several style cops — including
`Style/DirectiveScope`, the one that broke the 1.90.0 bump — are marked unsafe
and only `-A` corrects them. `-A` is acceptable **only** when followed by a
clean verification run:

```bash
bundle exec rubocop -A
bundle exec rubocop          # must end on "no offenses detected"
git -C .. diff               # eyeball a few hunks: the rewrite must be a no-op
```

Some cops have no autocorrect at all: `-a` and `-A` leave the count
unchanged. `RSpecRails/ReceivePerformLater` (rubocop-rspec_rails 2.33) is
one: it bans `expect(Job).to receive(:perform_later)` in favour of
`have_enqueued_job`. Rewrite those by hand, keeping what each example
asserts; with the `:test` queue adapter, block form
`expect { subject }.to have_enqueued_job(Job).with(...)`, chained with
`.and`, and `.exactly(n).times` to replace a `not_to receive` on the
records that must be skipped. A hand rewrite of a spec is not a no-op by
construction, so prove it still bites: run it, then temporarily break the
behaviour it covers (drop a scope from the query) and check it fails.

Running specs needs the test database env file that only a worktree made by
`bin/setup_worktree.sh` has: do the rewrite in the scratch worktree, run the
spec from the session's own worktree after checking the Dependabot branch out
there if the env file cannot be copied over.

Then commit and push:

```bash
git -C .. status --short | grep -v '^ M siade/'   # nothing outside the app
git -C .. add -A
git -C .. commit -m "Linting"
git -C .. push
```

Wait for the CI, then approve and merge as usual:

```bash
until [ "$(gh pr checks <pr> --json bucket --jq '[.[] | select(.bucket=="pending")] | length')" = "0" ]; do
  sleep 20
done
gh pr checks <pr> --json name,bucket --jq '.[] | "\(.name): \(.bucket)"'
```

Finally, clean up:

```bash
git worktree remove --force "$SCRATCHPAD/rubocop-siade"
git branch -D dependabot/bundler/siade/rubocop-xxxxxxxx
```

## A dev-only bump that goes major in the lockfile

Seen in September 2026: `bump the rubocop group in /siade` was a plain
1.90.0 → 1.91.0 dev bump, Lint was green, yet `Tests` failed on all 5704
examples and swagger generation died. `siade/Gemfile` carried no `json` pin, so
rubocop's own `json >= 2.3` requirement re-resolved json 2.21.2 → 3.0.2, taking
a production gem to a major behind a `deps-dev` title.

How to recognise it: the lockfile diff moves a gem nobody in the PR title
mentions, and the failures are a single error repeated everywhere. Find the
real origin rather than reading rspec's filtered backtrace, which only shows
application frames:

```bash
bundle exec ruby -e 'require "active_support/all"; p ActiveSupport::JSON.decode(%q({"a":1}))'
```

The fix is a pin in the `Gemfile`, not a revert of the lockfile — a lockfile
revert comes back next week. It changes a production constraint, so it is a PR
of its own, which the user reviews.

Do not then wait for Dependabot to rebase: carry the bumps it was blocking into
that same PR, one commit per group, and say in each message which Dependabot PR
it supersedes. With the pin in place, ask bundler for those gems only:

```bash
cd siade && bundle update rubocop rubocop-checkstyle_formatter
cd ../site && bundle update jwt
git diff -- '*/Gemfile.lock' | grep -E "^[+-] +[a-z0-9_-]+ \([0-9]"
```

Check that the constrained gem did not move, run `bundle exec rubocop` in both
apps for a rubocop bump, and run the specs covering the bumped gem. The
superseded PRs close themselves once it merges, which is how the week ends with
zero open Dependabot PR.

## Key facts (do not relearn)

- The Dependabot author filter is `app/dependabot`, not `dependabot[bot]`.
- Dependabot groups are configured per app: `rubocop`,
  `development-dependencies`, `production-dependencies`. The group name is in
  the PR title and tells you the blast radius.
- The commit message for a lint repair is exactly `Linting`.
- `json` is no longer pinned: the `< 3` pins of `siade/Gemfile` and
  `site/Gemfile` were dropped once Rails 8.1.4 shipped (7cfcc88496). json 3
  had made the `JSON.parse` / `JSON.generate` options keyword-only, which
  `ActiveSupport::JSON.decode` up to 8.1.3.1 broke on. json 3.x minors now come
  through the rubocop and dependency groups as ordinary bumps; a json 4, or a
  Rails downgrade below 8.1.4, brings the September incident back.
- `Style/DirectiveScope` rewrites a `disable` / `enable` pair around a single
  statement into `disable-next`. `disable-next` covers the whole next
  expression, multi-line methods included — unlike `disable-next-line`. That is
  why its autocorrect is safe in practice despite being flagged unsafe.
