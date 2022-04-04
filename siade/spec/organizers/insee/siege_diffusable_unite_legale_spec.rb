RSpec.describe INSEE::SiegeDiffusableUniteLegale, type: :retriever_organizer do
  subject { described_class.call(params:) }

  let(:params) do
    {
      siren:
    }
  end

  context 'with a valid siren', vcr: { cassette_name: 'insee/siege/active_GE_with_token' } do
    let(:siren) { sirens_insee_v3[:active_GE] }

    it { is_expected.to be_a_success }

    its(:resource) { is_expected.to be_present }
  end

  context 'with a non-existent siren', vcr: { cassette_name: 'insee/siege/non_existent_with_token' } do
    let(:siren) { non_existent_siren }

    it { is_expected.to be_a_failure }
  end

  context 'with an entrepreneur individuel non diffusable ceased', vcr: { cassette_name: 'insee/siege/non_diffusable_ceased_with_token' } do
    let(:siren) { confidential_siren(:non_diffusable_ceased) }

    it { is_expected.to be_a_failure }
  end

  context 'with an entrepreneur individuel non diffusable', vcr: { cassette_name: 'insee/siege/non_diffusable_with_token' } do
    let(:siren) { non_diffusable_siren }

    it { is_expected.to be_a_failure }
  end

  context 'with a gendarmerie', vcr: { cassette_name: 'insee/siege/gendarmerie_limousin_with_token' } do
    let(:siren) { confidential_siren(:gendarmerie_limousin) }

    it { is_expected.to be_a_failure }
  end

  context 'with a siren which redirects to another location', vcr: { cassette_name: 'insee/siege/redirected_with_token' } do
    let(:siren) { '532221694' }

    it { is_expected.to be_a_failure }
  end
end
