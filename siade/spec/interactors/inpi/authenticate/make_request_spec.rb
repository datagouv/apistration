RSpec.describe INPI::Authenticate::MakeRequest, type: :make_request do
  subject { described_class.call }

  describe 'happy path', vcr: { cassette_name: 'inpi/authenticate' } do
    it { is_expected.to be_a_success }

    its(:response) { is_expected.to be_a(Net::HTTPOK) }
  end
end
