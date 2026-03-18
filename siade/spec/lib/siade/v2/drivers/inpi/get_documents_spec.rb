RSpec.describe SIADE::V2::Drivers::INPI::GetDocuments, type: :provider_driver do
  subject(:driver) do
    described_class.new(ids_fichiers: ids_fichiers, cookie: valid_cookie_inpi).tap(&:perform_request)
  end

  context 'when documents are not found', vcr: { cassette_name: 'inpi_get_documents_not_found' } do
    let(:ids_fichiers) { ids_fichiers_inpi_not_found }

    its(:http_code) { is_expected.to eq 502 }
    its(:errors) { are_expected.to have_error('Erreur retournée par l\'INPI: Le type de document n\'est pas reconnu pour l\'id not found doc ID') }
  end

  context 'when documents are found', vcr: { cassette_name: 'inpi_get_documents' } do
    let(:ids_fichiers) { ids_fichiers_inpi }

    context 'when no error occurs with the document' do
      its(:http_code) { is_expected.to eq 200 }

      it 'has a valid URL for all actes' do
        expect(driver.url_documents)
          .to match(a_string_starting_with(Siade.credentials[:public_storage_url])
          .and(a_string_ending_with('-all_documents.zip')))
      end
    end

    context 'when there is something wrong with the documents' do
      before do
        allow_any_instance_of(SIADE::SelfHostedDocument::FormatValidator)
          .to receive(:valid?).and_return(false)
        driver.url_documents
      end

      its(:http_code) { is_expected.to eq(502) }
      its(:errors) { is_expected.to have_error('Le fichier n\'est pas au format `zip` attendu.') }
    end
  end
end
