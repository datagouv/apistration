RSpec.describe DGFIP::AttestationFiscale, :self_hosted_doc, type: :retriever_organizer do
  subject { described_class.call(params:) }

  let(:siren) { valid_siren }
  let(:user_id) { yes_jwt_user.id }
  let(:request_id) { SecureRandom.uuid }
  let(:params) do
    {
      siren:,
      user_id:,
      request_id:
    }
  end

  context 'with valid attributes' do
    context 'when DGFIP works' do
      let!(:stubbed_request) do
        mock_dgfip_authenticate

        stub_request(:get, %r{#{Siade.credentials[:dgfip_apim_base_url]}/adelie/v1/attestationFiscale}).with(
          headers: {
            'Content-Type' => 'application/json',
            'Authorization' => 'Bearer bearer_token',
            'X-Correlation-ID' => request_id,
            'X-Request-ID' => request_id
          },
          query: {
            'siren' => siren,
            'groupeIS' => 'NON',
            'groupeTVA' => 'NON',
            'userId' => user_id
          }
        ).to_return(
          status: 200,
          body: extract_valid_dgfip_attestation_fiscale_pdf
        )
      end

      it { is_expected.to be_a_success }

      it 'calls the stubbed request', :disable_vcr do
        subject

        expect(stubbed_request).to have_been_requested
      end

      it 'uploads the attestation on the self hosted storage' do
        document_url = subject.bundled_data.data.document_url

        expect(document_url).to be_a_valid_self_hosted_pdf_url('attestation_fiscale_dgfip')
      end

      its(:cacheable) { is_expected.to be(true) }
    end
  end

  context 'with invalid attributes' do
    let(:siren) { 'invalid' }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
  end
end
