RSpec.describe FabriqueNumeriqueMinisteresSociaux::ConventionsCollectives::MakeRequest, type: :make_request do
  subject { described_class.call(params:) }

  let(:params) do
    {
      siret:
    }
  end

  context 'when siret is valid' do
    let(:siret) { valid_siret(:conventions_collectives) }

    before { stub_fabrique_numerique_conventions_collectives_valid }

    it { is_expected.to be_success }

    its(:response) { is_expected.to be_a(Net::HTTPOK) }
  end

  context 'when siret is not found' do
    let(:siret) { not_found_siret(:conventions_collectives) }

    before { stub_fabrique_numerique_conventions_collectives_not_found }

    it { is_expected.to be_success }

    its(:response) { is_expected.to be_a(Net::HTTPOK) }
  end
end
