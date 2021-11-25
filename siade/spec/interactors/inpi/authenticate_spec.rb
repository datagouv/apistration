RSpec.describe INPI::Authenticate, type: :organizer do
  subject { described_class.call }

  let(:inpi_url) { Siade.credentials[:inpi_url] }
  let(:url_pattern) { Regexp.new(/#{inpi_url}/) }

  context 'when authentication is successful', vcr: { cassette_name: 'inpi/authenticate' } do
    it { is_expected.to be_a_success }

    its(:cookie) { is_expected.to eq 'JSESSIONID=D63E8862B36FABAAC2B07C706A4EF2E3' }
  end

  context 'when authentication is failure' do
    before do
      stub_request(:post, url_pattern).to_return({
        status: 200,
        body: 'response without cookie in header',
        headers: {}
      })
    end

    it { is_expected.to be_a_failure }

    its(:cookie) { is_expected.to be_nil }
  end
end

