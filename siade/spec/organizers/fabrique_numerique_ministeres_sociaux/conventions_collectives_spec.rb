RSpec.describe FabriqueNumeriqueMinisteresSociaux::ConventionsCollectives, type: :retriever_organizer do
  subject { described_class.call(params: params) }

  let(:params) do
    {
      siret: siret
    }
  end

  context 'when siret is valid', vcr: { cassette_name: 'fabrique_numerique_ministeres_sociaux/conventions_collectives/valid_siret' } do
    let(:siret) { valid_siret(:conventions_collectives) }

    it { is_expected.to be_success }

    its(:resource_collection) { is_expected.to be_present }
    its(:meta) { is_expected.to be_present }
  end

  context 'when siret is not found', vcr: { cassette_name: 'fabrique_numerique_ministeres_sociaux/conventions_collectives/not_found_siret' } do
    let(:siret) { not_found_siret(:conventions_collectives) }

    it { is_expected.to be_a_failure }
  end
end
