# Harden prenoms validation in Civility::ValidatePrenoms

## Context

While debugging a MEN `ScolaritesWithCivilityController` request that came
back with an opaque provider 400 (`"La syntaxe de la requête est erronée ou
un paramètre n'a pas le bon format"`), we traced the cause to the request's
`prenoms` param: `["LILY-ROSE, CLARA"]` — a single array element containing
two given names joined by a literal comma, instead of two separate array
elements (`["LILY-ROSE", "CLARA"]`).

`MEN::Scolarites::MakeRequest#prenom` takes `params[:prenoms].first` as-is
and forwards it to MEN, which rejects the comma. Our own validation chain
let it through because `Civility::ValidatePrenoms`
(`siade/app/interactors/civility/validate_prenoms.rb`) only checks the
*shape* of `prenoms` (non-empty array of strings, via the shared
`ValidatePrenomsFormat` module) — it has no character-level check.

Two sibling validators already solve this for their own providers:
`CNAV::ValidatePrenoms` and `DSNJ::ServiceNational::ValidatePrenoms` each
add a `valid_characters?` regex check on top of the shape check, rejecting
anything outside letters/accents/apostrophe/hyphen/space (DSNJ's also
allows Æ/æ). `Civility::ValidatePrenoms` never got the same treatment.

`Civility::ValidatePrenoms` is not MEN-specific — it's shared by six
providers' `ValidateParams` chains: ANTS (`ExtraitImmatriculationVehicule`),
FranceConnect, GIP-MDS Service Civique, MEN Scolarites, MESRI Student
Status With Civility, and CNOUS Student Scholarship With Civility. All six
are exposed to the same malformed-input-forwarded-to-provider risk today.

## Goal

When `prenoms` contains characters outside the expected French given-name
charset (e.g. a comma from two names crammed into one array element),
reject the request at our validation layer with a clean, existing 422
error — instead of forwarding it to the data provider and surfacing
whatever opaque error that provider happens to return.

## Design

Add a `valid_characters?` check to `Civility::ValidatePrenoms`, mirroring
`DSNJ::ServiceNational::ValidatePrenoms`'s existing pattern exactly:

```ruby
class Civility::ValidatePrenoms < ValidateParamInteractor
  include ValidatePrenomsFormat

  def call
    return invalid_param!(:prenoms) unless valid_prenoms_format?

    invalid_param!(:prenoms) unless valid_characters?
  end

  private

  def valid_characters?
    param(:prenoms).all? { |p| /\A[a-zA-ZÀ-ÖØ-öø-ÿÆæ' -]+\z/.match?(p) }
  end
end
```

Charset: DSNJ's superset (letters, accented Latin range, Æ/æ, apostrophe,
hyphen, space) rather than CNAV's narrower one (no Æ/æ) — strictly more
permissive, so no risk of rejecting a name CNAV would accept, and a
reasonable default for a validator shared across six providers with varied
populations.

No new shared module is introduced. `CNAV::ValidatePrenoms`,
`DSNJ::ServiceNational::ValidatePrenoms`, and `Civility::ValidatePrenoms`
each keep their own explicit `valid_characters?` — consistent with how
this codebase already treats these three as intentionally separate
validators that may diverge (DSNJ's charset already differs from CNAV's
today).

### Error surfaced

Reuses the existing `:prenoms` error kind → `UnprocessableEntityError` →
code `00421` (`"Le(s) prenom(s) est manquant"`), the same kind already
used for the shape-check failure. This mirrors `DSNJ::ServiceNational::
ValidatePrenoms`, which already reuses its own single `:prenoms`/kind for
both its format and character check failures — not a new inconsistency.

### Blast radius

Fixes all six providers routing through `Civility::ValidatePrenoms` in one
change: ANTS, FranceConnect, GIP-MDS Service Civique, MEN Scolarites,
MESRI Student Status, CNOUS Student Scholarship.

### Compatibility check performed

Grepped every existing spec fixture across all six providers' request and
organizer specs that feeds `prenoms` values into this chain (`Jean`,
`Charlie`, `Jean Charlie`, `Shinobi Wolf`, `prenom`, `jean charlie`, etc.).
All fit the proposed charset — no existing spec is expected to break.

## Testing

Extend `spec/interactors/civility/validate_prenoms_spec.rb` with explicit
`context` blocks (no `shared_examples`/`include_examples`/
`it_behaves_like`, per project convention) covering:

- Valid names with accents, apostrophe, hyphen (already covered by
  existing "with valid prenoms" context — may extend with an accented
  example).
- The repro case: `['LILY-ROSE, CLARA']` → failure.
- Digits in a prenom → failure.
- Other forbidden punctuation (e.g. `/`, `!`) → failure.

## Out of scope

- Splitting `"LILY-ROSE, CLARA"` into two array elements automatically
  (silent reinterpretation of malformed client input) — reject and let
  the caller fix their request instead.
- Touching `CNAV::ValidatePrenoms` or `DSNJ::ServiceNational::
  ValidatePrenoms` — both already have their own working character check.
- Client SDK changes — this is a server-side input validation fix, not an
  API signature change (no endpoint, parameter, or response format
  changes).
