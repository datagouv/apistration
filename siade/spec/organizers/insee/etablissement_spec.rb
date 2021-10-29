RSpec.describe INSEE::Etablissement, type: :retriever_organizer do
  subject { described_class.call(params: params) }

  let(:params) do
    {
      siret: siret
    }
  end

  context 'with a valid siret, which is an active GE', vcr: { cassette_name: 'insee/siret/active_GE_with_token' } do
    let(:siret) { sirets_insee_v3[:active_GE] }

    it { is_expected.to be_a_success }

    its(:resource) { is_expected.to be_present }
  end

  context 'with an entrepreneur individuel non diffusable', vcr: { cassette_name: 'insee/siret/non_diffusable_with_token' } do
    let(:siret) { non_diffusable_siret }

    it { is_expected.to be_a_success }

    its(:resource) { is_expected.to be_present }
  end
end
