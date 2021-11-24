RSpec.describe DGFIP::Authenticate::MakeRequest, type: :make_request do
  subject { described_class.call }

  context 'when it works', vcr: { cassette_name: 'dgfip/authenticate/valid' } do
    it { is_expected.to be_a_success }

    its(:response) { is_expected.to be_a(Net::HTTPOK) }
  end

  context 'when there is an invalid secret', vcr: { cassette_name: 'dgfip/authenticate/wrong_secret' } do
    before do
      stub_credential(:dgfip_secret, 'wrong_secret')
    end

    it { is_expected.to be_a_success }

    its(:response) { is_expected.to be_a(Net::HTTPOK) }
  end
end
