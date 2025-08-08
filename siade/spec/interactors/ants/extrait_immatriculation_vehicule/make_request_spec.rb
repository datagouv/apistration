RSpec.describe ANTS::ExtraitImmatriculationVehicule::MakeRequest, type: :make_request do
  describe '.call' do
    subject { described_class.call(params:) }

    let(:params) { { immatriculation:, request_id: } }
    let(:body) do
      ANTSDossierImmatriculationSoapBuilder.new(
        immatriculation:,
        request_id:,
        certificate:,
        private_key:
      ).render
    end
    let!(:stubbed_request) do
      stub_request(:post, Siade.credentials[:ants_siv_url]).with { |request|
        request.body.include?('<ns1:num_immat>AA-123-AA</ns1:num_immat>') &&
          request.body.include?('<saml:AttributeValue>ants_siv_code_concentrateur</saml:AttributeValue>') &&
          request.body.include?('----')
      }.to_return(
        status: 200,
        body: '<soap:Envelope><soap:Body>Success</soap:Body></soap:Envelope>'
      )
    end
    let(:immatriculation) { 'AA-123-AA' }
    let(:request_id) { SecureRandom.uuid }

    let(:private_key) { instance_double(OpenSSL::PKey::RSA) }
    let(:certificate) { instance_double(OpenSSL::X509::Certificate) }

    before do
      allow(certificate).to receive(:to_der).and_return('dummy_cert_der')
      allow(private_key).to receive(:sign).with(
        instance_of(OpenSSL::Digest),
        instance_of(String)
      ).and_return('dummy_key_signature')

      allow(File).to receive(:read).and_call_original
      allow(File).to receive(:read).with(Siade.credentials[:ssl_wildcard_certif_key_path]).and_return('dummy_key')
      allow(File).to receive(:read).with(Siade.credentials[:ssl_wildcard_certif_crt_path]).and_return('dummy_cert')

      allow(OpenSSL::PKey::RSA).to receive(:new).with('dummy_key').and_return(private_key)
      allow(OpenSSL::X509::Certificate).to receive(:new).with('dummy_cert').and_return(certificate)
    end

    it { is_expected.to be_a_success }

    it 'calls url with correct params' do
      subject

      expect(stubbed_request).to have_been_requested
    end
  end
end
