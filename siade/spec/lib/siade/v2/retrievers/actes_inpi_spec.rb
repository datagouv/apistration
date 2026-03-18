RSpec.describe SIADE::V2::Retrievers::ActesINPI do
  subject { described_class.new(siren, valid_cookie_inpi).tap(&:retrieve) }

  describe 'bad formatted siren' do
    let(:siren) { invalid_siren }

    its(:success?) { is_expected.to be_falsey }
    its(:http_code) { is_expected.to eq 422 }
    its(:errors) { is_expected.to have_error(invalid_siren_error_message) }
  end

  describe 'non existent siren', vcr: { cassette_name: 'inpi_actes_not_found' } do
    let(:siren) { not_found_siren(:inpi) }

    its(:success?) { is_expected.to be_falsey }
    its(:http_code) { is_expected.to eq 404 }
    its(:errors) { is_expected.to have_error('Le siret ou siren indiqué n\'existe pas, n\'est pas connu ou ne comporte aucune information pour cet appel') }
  end

  describe 'documents cannot be retrieved', vcr: { cassette_name: 'inpi_get_documents_not_found' } do
    before do
      allow_any_instance_of(described_class)
        .to receive(:ids_fichiers)
        .and_return(ids_fichiers_inpi_not_found)
    end

    let(:siren) { valid_siren(:inpi_pdf) }

    its(:success?) { is_expected.to be_falsey }
    its(:http_code) { is_expected.to eq 502 }
  end

  describe 'valid siren', vcr: { cassette_name: 'inpi_actes_valid_siren' } do
    let(:siren) { valid_siren(:inpi_pdf) }

    its(:success?) { is_expected.to be_truthy }
    it { is_expected.to be_delegated_to SIADE::V2::Drivers::INPI::Actes, :actes }
    it { is_expected.to be_delegated_to SIADE::V2::Drivers::INPI::GetDocuments, :url_documents }
  end
end
