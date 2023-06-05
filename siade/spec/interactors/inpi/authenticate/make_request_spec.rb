RSpec.describe INPI::Authenticate::MakeRequest, type: :make_request do
  subject { described_class.call }

  describe 'when authentication is a success', vcr: { cassette_name: 'inpi/authenticate' } do
    it { is_expected.to be_a_success }

    its(:response) { is_expected.to be_a(Net::HTTPOK) }
  end

  describe 'when authentication failed' do
    let(:inpi_url) { Siade.credentials[:inpi_url] }
    let(:url_pattern) { /#{inpi_url}/ }

    before do
      stub_request(:post, url_pattern).to_return({
        status: 200,
        body: 'response without cookie in header',
        headers: {}
      })
    end

    it { is_expected.to be_a_success }
  end
end
