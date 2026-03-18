RSpec.describe API::V2::CertificatsQUALIBATController, type: :controller do
  it_behaves_like 'unauthorized'
  it_behaves_like 'unprocessable_entity', :show, :siret
  it_behaves_like 'forbidden'
  it_behaves_like 'ask_for_mandatory_parameters'

  describe 'happy path' do
    context 'when etablissement is not known from qualibat', vcr: { cassette_name: 'qualibat_with_not_found_siret' } do
      it_behaves_like 'not_found', siret: not_found_siret(:qualibat)
    end

    context 'when etablissement is eligible for certificate', vcr: { cassette_name: 'qualibat_with_valid_siret' } do
      it_behaves_like 'happy_pdf_endpoint_siret', valid_siret(:qualibat), 'certificat_qualibat'
    end
  end
end
