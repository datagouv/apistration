RSpec.describe SIADE::V2::Requests::INPI::Authenticate, type: :provider_request do
  subject { described_class.new }

  context 'when authentication is successful', vcr: { cassette_name: 'inpi_cookie' } do
    its(:cookie) { is_expected.to eq 'JSESSIONID=D63E8862B36FABAAC2B07C706A4EF2E3' }
  end

  context 'when authentication is failure' do
    before do
      inpi_url = Siade.credentials[:inpi_url]
      url_pattern = /#{inpi_url}/
      stub_request(:post, url_pattern).to_return({
        status:  200,
        body:    'response without cookie in header',
        headers: {}
      })
    end

    its(:cookie) { is_expected.to be_nil }
  end

  context 'when authentication timed out' do
    before do
      inpi_url = Siade.credentials[:inpi_url]
      url_pattern = /#{inpi_url}/
      stub_request(:post, url_pattern).to_raise(Net::OpenTimeout)
    end

    its(:cookie) { is_expected.to be_nil }
  end

  context 'when authentication failed (No address associated with hostname)' do
    before do
      inpi_url = Siade.credentials[:inpi_url]
      url_pattern = /#{inpi_url}/
      stub_request(:post, url_pattern).to_raise(SocketError)
    end

    its(:cookie) { is_expected.to be_nil }
  end

  context 'when authentication failed (end of file reached)' do
    before do
      inpi_url = Siade.credentials[:inpi_url]
      url_pattern = /#{inpi_url}/
      stub_request(:post, url_pattern).to_raise(EOFError)
    end

    its(:cookie) { is_expected.to be_nil }
  end
end
