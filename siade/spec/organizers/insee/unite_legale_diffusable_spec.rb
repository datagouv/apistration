RSpec.describe INSEE::UniteLegaleDiffusable, type: :retriever_organizer do
  subject { described_class.call(params: params) }

  let(:params) do
    {
      siren: siren
    }
  end

  context 'with a valid siren, which is an active GE', vcr: { cassette_name: 'insee/siren/active_GE_with_token' } do
    let(:siren) { sirens_insee_v3[:active_GE] }

    it { is_expected.to be_a_success }

    its(:resource) { is_expected.to be_present }
  end

  context 'with an entrepreneur individuel non diffusable', vcr: { cassette_name: 'insee/siren/non_diffusable_with_token' } do
    let(:siren) { non_diffusable_siren }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(NotFoundError) }
    its(:resource) { is_expected.to be_nil }
  end
end
