RSpec.describe API::V2::AttestationsCotisationRetraitePROBTPController, type: :controller do
  it_behaves_like 'unauthorized'
  it_behaves_like 'unprocessable_entity', :show, :siret
  # TODO: Alexis no vcr error here
  # it_behaves_like 'not_found', not_found_siret(:probtp)
  it_behaves_like 'forbidden'
  it_behaves_like 'ask_for_mandatory_parameters'

  describe 'happy path' do
    subject { JSON.parse(response.body, symbolize_names: true) }

    let(:url) { 'https://probtp_domain.gouv.fr/ws_ext/rest/certauth/mpsservices/getAttestationCotisation' }

    before do
      stub_request(:post, url).with(
        body: { corps: siret }.to_json,
        headers: { 'Content-Type' => 'application/json' }
      ).to_return(stub_response)

      get :show, params: { siret: siret, token: token }.merge(mandatory_params)
    end

    context 'when user authenticates with valid token' do
      let(:token) { yes_jwt }

      context 'when etablissement is unknown from PROBTP' do
        let(:siret) { non_existent_siret }
        let(:stub_response) { { status: 200, body: "{\n  \"entete\" : {\n    \"code\" : \"8\",\n    \"message\" : \"SIRET #{siret} inconnu de nos services\"\n  }\n}" } }

        it_behaves_like 'not_found'
      end

      context 'siret eligible PROBTP' do
        let(:siret) { valid_siret(:probtp) }

        context 'when the PDF returned from PROBTP is not valid' do
          let(:stub_response) { { status: 200, body: "{\n  \"entete\" : {\n    \"code\" : \"0\"\n  },\n  \"data\" : \"#{encode64_payload_file('pdf/bad.pdf')}\" }" } }

          it 'returns 502' do
            expect(response).to have_http_status(:bad_gateway)

            expect(subject).to have_json_error(
              code: '09055',
              detail: bad_pdf_error_message
            )
          end
        end

        context 'when the PDF returned from PROBTP is valid' do
          let(:stub_response) { { status: 200, body: "{\n  \"entete\" : {\n    \"code\" : \"0\"\n  },\n  \"data\" : \"#{encode64_payload_file('pdf/dummy.pdf')}\" }" } }

          it 'returns 200 with a link to the PDF', vcr: { cassette_name: 'probtp/check_pdf' } do
            expect(response).to have_http_status(:ok)
            expect(subject[:url]).to match(/attestation_cotisation_retraite_probtp.pdf\z/)
          end
        end
      end
    end
  end
end
