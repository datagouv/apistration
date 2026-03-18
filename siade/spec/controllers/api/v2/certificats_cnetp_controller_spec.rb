RSpec.describe API::V2::CertificatsCNETPController, type: :controller do
  it_behaves_like 'unauthorized'
  it_behaves_like 'unprocessable_entity'
  it_behaves_like 'forbidden'
  it_behaves_like 'ask_for_mandatory_parameters'

  describe 'happy path' do
    context 'when siren is unknown from CNETP', vcr: { cassette_name: 'cnetp_with_not_found_siren' } do
      it_behaves_like 'not_found'
    end

    context 'when a certificate is returned', vcr: { cassette_name: 'cnetp_with_valid_siren' } do
      it_behaves_like 'happy_pdf_endpoint_siren', valid_siren(:cnetp), 'certificat_cnetp'
    end
  end
end
