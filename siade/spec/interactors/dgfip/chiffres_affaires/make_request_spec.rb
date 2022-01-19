RSpec.describe DGFIP::ChiffresAffaires::MakeRequest, type: :make_request do
  subject { described_class.call(cookie: cookie, params: params) }

  let(:params) do
    {
      siret: siret,
      user_id: user_id
    }
  end
  let(:cookie) { DGFIP::Authenticate.call.cookie }

  describe 'happy path', vcr: { cassette_name: 'dgfip/chiffres_affaires/valid' } do
    let(:siret) { valid_siret(:exercice) }
    let(:user_id) { valid_dgfip_user_id }

    it { is_expected.to be_a_success }

    its(:response) { is_expected.to be_a(Net::HTTPOK) }
  end

  context 'with a non existent siret', vcr: { cassette_name: 'dgfip/chiffres_affaires/not_found' } do
    let(:siret) { non_existent_siret }
    let(:user_id) { valid_dgfip_user_id }

    it { is_expected.to be_a_success }

    its(:response) { is_expected.to be_a(Net::HTTPOK) }
  end
end
