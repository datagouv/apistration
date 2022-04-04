RSpec.describe FabriqueNumeriqueMinisteresSociaux::ConventionsCollectives::MakeRequest, type: :make_request do
  subject { described_class.call(params:) }

  let(:params) do
    {
      siret:
    }
  end

  context 'when siret is valid', vcr: { cassette_name: 'fabrique_numerique_ministeres_sociaux/conventions_collectives/valid_siret' } do
    let(:siret) { valid_siret(:conventions_collectives) }

    it { is_expected.to be_success }

    its(:response) { is_expected.to be_a(Net::HTTPOK) }
  end

  context 'when siret is not found', vcr: { cassette_name: 'fabrique_numerique_ministeres_sociaux/conventions_collectives/not_found_siret' } do
    let(:siret) { not_found_siret(:conventions_collectives) }

    it { is_expected.to be_success }

    its(:response) { is_expected.to be_a(Net::HTTPOK) }
  end
end
