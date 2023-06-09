RSpec.describe GIPMDS::EffectifsMensuelsEtablissement::ValidateParams, type: :validate_params do
  subject { described_class.call(params:) }

  let(:params) do
    {
      siret:,
      year:,
      month:,
      depth:
    }
  end

  let(:siret) { valid_siret }
  let(:year) { '1990' }
  let(:month) { '07' }
  let(:depth) { '1' }

  context 'with valid params' do
    it { is_expected.to be_a_success }
  end

  context 'with empty depth' do
    let(:depth) { nil }

    it { is_expected.to be_a_success }
  end

  context 'with invalid depth' do
    let(:depth) { 'invalid' }

    it { is_expected.to be_a_failure }
  end

  context 'with a depth of 14' do
    let(:depth) { '14' }

    it { is_expected.to be_a_failure }
  end

  context 'with invalid siret' do
    let(:siret) { invalid_siret }

    it { is_expected.to be_a_failure }
  end

  context 'with an invalid year' do
    let(:year) { 'not a year' }

    it { is_expected.to be_a_failure }
  end

  context 'with an invalid month' do
    let(:month) { 'not a month' }

    it { is_expected.to be_a_failure }
  end
end
