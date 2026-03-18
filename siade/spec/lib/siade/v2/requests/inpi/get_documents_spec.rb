RSpec.describe SIADE::V2::Requests::INPI::GetDocuments, type: :provider_request do
  subject { described_class.new(ids_fichiers, valid_cookie_inpi).tap(&:perform) }

  context 'invalid IDs fichiers' do
    let(:ids_fichiers) { 'not an array' }

    its(:valid?) { is_expected.to be_falsey }
    its(:http_code) { is_expected.to eq 502 }
    its(:errors) { are_expected.to have_error('Les IDs fichiers renvoyés par l\'INPI sont incorrects') }
  end

  context 'IDs fichiers not found', vcr: { cassette_name: 'inpi_get_documents_not_found' } do
    let(:ids_fichiers) { ids_fichiers_inpi_not_found }

    its(:valid?) { is_expected.to be_truthy }
    its(:http_code) { is_expected.to eq 502 }
    its(:errors) { are_expected.to have_error("Erreur retournée par l'INPI: Le type de document n'est pas reconnu pour l'id not found doc ID") }
  end

  context 'valid IDs fichiers', vcr: { cassette_name: 'inpi_get_documents' } do
    let(:ids_fichiers) { ids_fichiers_inpi }

    its(:valid?) { is_expected.to be_truthy }
    its(:http_code) { is_expected.to eq 200 }
    its(:errors) { are_expected.to be_empty }
    its(:response) { is_expected.to be_a(SIADE::V2::Responses::INPI::GetDocuments) }
  end
end
