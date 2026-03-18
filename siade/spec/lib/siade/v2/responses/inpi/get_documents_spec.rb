RSpec.describe SIADE::V2::Responses::INPI::GetDocuments, type: :provider_response do
  subject do
    SIADE::V2::Requests::INPI::GetDocuments
      .new(ids_fichiers, valid_cookie_inpi)
      .tap(&:perform)
      .response
  end

  context 'when documents are not found', vcr: { cassette_name: 'inpi_get_documents_not_found' } do
    let(:ids_fichiers) { ids_fichiers_inpi_not_found }

    its(:http_code) { is_expected.to eq 502 }
  end

  context 'when documents are found', vcr: { cassette_name: 'inpi_get_documents' } do
    let(:ids_fichiers) { ids_fichiers_inpi }

    its(:http_code) { is_expected.to eq 200 }
  end
end
