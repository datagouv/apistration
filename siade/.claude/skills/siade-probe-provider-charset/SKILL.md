---
name: siade-probe-provider-charset
description: Use when hardening, reviewing, or debating a character/format restriction on an identity field (prenoms, nom_naissance, etc.) sent to a SIADE data provider — deciding whether to forbid digits, brackets, comma, apostrophes, accents or hyphens in Civility::ValidatePrenoms or a provider-specific validator, when a PR reviewer disputes a new validation rule, or when asked which characters a given provider (MEN, MESRI, CNOUS, GIP-MDS, CNAV, DSNJ, ANTS...) actually accepts or rejects in a name field.
---

# Probe Provider Character Acceptance

## Overview

Client-side character restrictions on identity fields should be backed by what
the provider actually rejects, not assumption. This skill calls a provider's
real `MakeRequest` interactor directly — bypassing SIADE's own validators —
with a fake baseline identity and one character variation at a time, then
compares HTTP responses to tell accepted formats (a functional "not found")
from genuinely rejected ones (a format error).

**Must run in a sandbox Rails console.** Outside prod, `MakeRequest` hits
SIADE's own mocks (`MockedDataHelper#use_mocked_data?`) and dev/staging
typically can't reach these provider networks anyway (firewalling,
sandbox-only credentials) — every command below assumes prod.

## When to Use

- Deciding whether to add/remove a character from a shared validator
  (`Civility::ValidatePrenoms` / `ValidatePrenomsFormat`, or a provider's own
  `valid_characters?`)
- A PR reviewer disputes a new forbidden-character rule ("is this actually
  necessary?")
- Investigating a provider 400/422 caused by a specific character in a name
  field
- Any "which characters does provider X accept in field Y" question

## Step 1 — Only test providers that actually forward the field

A shared validator is often reused across several provider organizers, but
not every one of them sends the field to the provider — some only use it for
**local identity matching** against the provider's response (e.g. ANTS
matches `prenoms` against the SIV vehicle-owner name; the value never appears
in `request_params`). Testing those tells you nothing.

For each organizer that includes the validator under test:

1. Find its `MakeRequest` interactor (`app/interactors/<provider>/.../make_request.rb`)
2. Check `request_params` (and `mocking_params`) — if the field isn't in
   there, skip this provider
3. Note whether it needs a token (`token_interactor` in `config/pings.yml`,
   or the organizer's `organize` list) and any `organizer_params`

## Step 2 — Gather a valid baseline

Pull known-good params for everything **except** the field under test from
`config/pings.yml` (`shared:` section) or existing specs — don't invent
reference codes (e.g. `code_etablissement`, `code_cog_insee_commune_naissance`);
a wrong one causes an unrelated 400 that muddies the read. Use an obviously
fake identity (`DUPONT` / `JEAN`, same as the ping system already sends to
prod routinely) — never a real person's name.

## Step 3 — Build the variation matrix

One character class per test case — **never combine two suspect characters**
in one string (e.g. `"GUIOT (2)"` conflates brackets and a digit; you won't
know which one caused a 400). Default set for a "which characters are
allowed" audit — add/remove rows to match whatever's actually in question:

| label | example value |
|---|---|
| baseline | `Jean` |
| digit | `GUIOT2` |
| round brackets | `GUIOT (BIS)` |
| square brackets | `GUIOT [BIS]` |
| comma | `GUIOT, BIS` |
| apostrophe | `O'BRIEN` |
| hyphen | `JEAN-PAUL` |
| accented / non-French Latin | `MUÑOZ` |
| leading/trailing space | ` GUIOT ` |
| dot | `GUIOT.` |

## Step 4 — Run in production

```ruby
test_values = {
  'baseline' => ['Jean'],
  'digit'    => ['GUIOT2']
  # ...one entry per row from step 3, same shape as the field being tested
}

def show(label, result)
  body = result.response&.body.to_s.dup.force_encoding('UTF-8').scrub
  puts "#{label.ljust(20)} HTTP #{result.response&.code}  #{body[0, 300]}"
end

token = SomeProvider::Authenticate.call.token # skip if no token_interactor
test_values.each do |label, value|
  result = SomeProvider::SomeEndpoint::MakeRequest.call(
    params: { **baseline_params_from_step_2, field_under_test: value },
    token: token # + recipient: JwtTokenService::DINUM_SIRET, organizer_params if needed
  )
  show(label, result)
end
```

Repeat per provider found in Step 1. Use the `siade-ping-provider` skill for
the exact call shape (token / `organizer_params` / `recipient`) each
provider expects.

## Step 5 — Interpret

- Same response shape as baseline (e.g. a functional 404 "not found") →
  **format accepted**, the provider just didn't match the fake identity
- A distinct 400/422-class "invalid format" error → **format genuinely
  rejected**

Only restrict client-side what's actually rejected by a provider that
validates format — a character every format-validating provider still
accepts has no basis for a blanket client-side rejection.

## Gotchas

- **Some organizers never forward the field** (Step 1) — don't waste a test
  on them.
- **Encoding crash on `puts`**: `String#byteslice` on a UTF-8 response body
  can cut a multi-byte character in half, and `puts` then throws
  `Encoding::UndefinedConversionError`. Use `.dup.force_encoding('UTF-8').scrub`
  and slice by character (`body[0, 300]`), not `byteslice`.
- Providers that don't validate format at all return the same (usually 404)
  response for every variation — that's a real finding (no client-side
  restriction is justified from their side), not a broken test.

## Related

`siade-ping-provider` — exact `MakeRequest.call` shape per provider (token,
`organizer_params`, `recipient`).
