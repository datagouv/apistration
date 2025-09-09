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
          request.body.include?('req_')
      }.to_return(
        status: 200,
        body: '<soap:Envelope><soap:Body>Success</soap:Body></soap:Envelope>'
      )
    end
    let(:immatriculation) { 'AA-123-AA' }
    let(:request_id) { SecureRandom.uuid }

    it { is_expected.to be_a_success }

    it 'calls url with correct params' do
      subject

      expect(stubbed_request).to have_been_requested
    end
  end
end
