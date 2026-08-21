# Harden prenoms validation in Civility::ValidatePrenoms Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Reject malformed `prenoms` values (e.g. a comma-separated composite name crammed into one array element) at our own validation layer with a clean 422, instead of forwarding them to the data provider and surfacing an opaque provider error.

**Architecture:** Add a `valid_characters?` regex check to `Civility::ValidatePrenoms`, mirroring the existing pattern already used by `DSNJ::ServiceNational::ValidatePrenoms`. This single shared interactor is used by six providers' `ValidateParams` chains (ANTS, FranceConnect, GIP-MDS, MEN, MESRI, CNOUS), so the fix applies to all of them at once.

**Tech Stack:** Ruby, RSpec (with `rspec-its`), Interactor gem pattern used throughout `siade/`.

---

Spec: `docs/superpowers/specs/2026-08-18-harden-prenoms-validation-design.md`

### Task 1: Add character validation to Civility::ValidatePrenoms

**Files:**
- Modify: `siade/app/interactors/civility/validate_prenoms.rb`
- Test: `siade/spec/interactors/civility/validate_prenoms_spec.rb`

- [ ] **Step 1: Write the failing tests**

Replace the full contents of `siade/spec/interactors/civility/validate_prenoms_spec.rb` with:

```ruby
RSpec.describe Civility::ValidatePrenoms, type: :validate_params do
  subject { described_class.call(params: { prenoms: }) }

  let(:prenoms) { %w[Loic Samuel Thomas] }

  context 'with valid prenoms' do
    it { is_expected.to be_a_success }

    its(:errors) { is_expected.to be_empty }
  end

  context 'with valid accented and compound prenoms' do
    let(:prenoms) { ['Zoé', 'Anne-Marie', 'N\'Guyen'] }

    it { is_expected.to be_a_success }

    its(:errors) { is_expected.to be_empty }
  end

  context 'with invalid user_id' do
    context 'when prenoms is empty' do
      let(:prenoms) { [] }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
    end

    context 'when prenoms is nil' do
      let(:prenoms) { nil }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
    end

    context 'when prenoms array contains a non-string element' do
      let(:prenoms) { ['Jean', { 'foo' => 'bar' }] }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
    end
  end

  context 'with invalid characters' do
    context 'when a prenom is a comma-separated composite name' do
      let(:prenoms) { ['LILY-ROSE, CLARA'] }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
    end

    context 'when a prenom contains a digit' do
      let(:prenoms) { %w[Jean123] }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
    end

    context 'when a prenom contains forbidden punctuation' do
      let(:prenoms) { %w[Jean/Paul] }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
    end
  end
end
```

Note: the pre-existing `context 'with invalid user_id'` label is a leftover
from a copy-pasted spec elsewhere in the codebase — leave it as-is, it's
out of scope for this change.

- [ ] **Step 2: Run the new tests to verify they fail**

Run: `cd siade && bundle exec rspec spec/interactors/civility/validate_prenoms_spec.rb -e "with invalid characters"`

Expected: `6 examples, 6 failures` — the `-e` filter matches all examples
whose full description contains "with invalid characters", i.e. both the
`it { is_expected.to be_a_failure }` and `its(:errors) { ... }` example in
each of the 3 nested contexts (3 × 2 = 6). All 6 fail because
`described_class` currently only validates array shape: it returns
`be_a_success` with an empty `errors` array for all three malformed
inputs, instead of the expected failure with an `UnprocessableEntityError`.

- [ ] **Step 3: Write the minimal implementation**

Replace the full contents of `siade/app/interactors/civility/validate_prenoms.rb` with:

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

- [ ] **Step 4: Run the full spec file to verify everything passes**

Run: `cd siade && bundle exec rspec spec/interactors/civility/validate_prenoms_spec.rb`

Expected: `16 examples, 0 failures` (2 "valid prenoms" + 2 "valid accented
and compound prenoms" + 6 "with invalid user_id" + 6 "with invalid
characters")

- [ ] **Step 5: Run Rubocop on the changed files**

Run: `cd siade && bundle exec rubocop app/interactors/civility/validate_prenoms.rb spec/interactors/civility/validate_prenoms_spec.rb`

Expected: `no offenses detected`

- [ ] **Step 6: Run the full interactor spec suite for the six affected providers to confirm no regressions**

Run: `cd siade && bundle exec rspec spec/organizers/ants/extrait_immatriculation_vehicule/validate_params_spec.rb spec/organizers/france_connect/validate_params_spec.rb spec/organizers/men/scolarites/validate_params_spec.rb spec/interactors/civility/validate_prenoms_spec.rb`

Expected: all examples pass, `0 failures` (GIP-MDS, MESRI, and CNOUS
`ValidateParams` organizer specs may not exist as standalone files — if any
path in this command errors with "No examples found", drop that path and
re-run with the rest; this is a sanity check, not evidence of new coverage).

- [ ] **Step 7: Commit**

```bash
cd siade
git add app/interactors/civility/validate_prenoms.rb spec/interactors/civility/validate_prenoms_spec.rb
git commit -m "$(cat <<'EOF'
Reject prenoms with invalid characters in Civility::ValidatePrenoms

A MEN Scolarites request with prenoms: ["LILY-ROSE, CLARA"] (two names
joined by a comma in one array element instead of two elements) was
forwarded as-is to the provider, which rejected it with an opaque 400.
Civility::ValidatePrenoms only checked array shape, unlike its CNAV and
DSNJ siblings which already reject invalid characters. This adds the same
character check, catching malformed input at our validation layer with a
clear 422 instead of round-tripping to the provider. Civility::ValidatePrenoms
is shared by six providers (ANTS, FranceConnect, GIP-MDS, MEN, MESRI, CNOUS),
so all six are covered.
EOF
)"
```
