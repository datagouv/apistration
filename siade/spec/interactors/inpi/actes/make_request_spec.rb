RSpec.describe INPI::Actes::MakeRequest, type: :make_request do
  subject { described_class.call(cookie: valid_cookie_inpi, params: params) }

  let(:params) do
    { siren: siren }
  end

  describe 'happy path', vcr: { cassette_name: 'inpi/actes/with_valid_siren' } do
    let(:siren) { valid_siren(:inpi) }

    it { is_expected.to be_a_success }

    its(:response) { is_expected.to be_a(Net::HTTPOK) }
  end
end
