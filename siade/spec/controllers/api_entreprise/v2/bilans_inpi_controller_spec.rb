RSpec.describe APIEntreprise::V2::BilansINPIController, type: :controller do
  before do
    allow_any_instance_of(SIADE::V2::Requests::INPI::Authenticate)
      .to receive(:cookie)
      .and_return(valid_cookie_inpi)
  end

  it_behaves_like 'unauthorized'
  it_behaves_like 'unprocessable_entity'
  it_behaves_like 'forbidden'
  it_behaves_like 'ask_for_mandatory_parameters'
  it_behaves_like 'inpi authentication failure'

  context 'when siren not found', vcr: { cassette_name: 'inpi_bilans_not_found' } do
    it_behaves_like 'not_found', siren: not_found_siren(:inpi)
  end

  context 'with valid siren but invalid documents', vcr: { cassette_name: 'inpi_get_documents_not_found' } do
    before do
      allow_any_instance_of(SIADE::V2::Retrievers::BilansINPI)
        .to receive(:ids_fichiers)
        .and_return(ids_fichiers_inpi_not_found)

      get :show, params: { siren: siren, token: yes_jwt }.merge(mandatory_params)
    end

    let(:siren) { valid_siren(:inpi_pdf) }

    it 'returns HTTP code 502' do
      expect(response).to have_http_status :bad_gateway
    end

    it 'returns an error' do
      expect(response_json).to have_json_error(detail: 'Erreur retournée par l\'INPI: Le type de document n\'est pas reconnu pour l\'id not found doc ID')
    end
  end

  context 'with valid siren', vcr: { cassette_name: 'inpi_get_documents' } do
    before do
      get :show, params: { siren: siren, token: yes_jwt }.merge(mandatory_params)
    end

    let(:siren) { valid_siren :inpi_pdf }

    it 'returns HTTP code 200' do
      expect(response).to have_http_status :ok
    end

    it 'has valid payload' do
      expected_json = {
        url_documents: a_string_starting_with(Siade.credentials[:public_storage_url]).and(a_string_ending_with('-all_documents.zip')),
        bilans: [
          { id_fichier: 12_294_537, siren: '393463187', denomination_sociale: nil, code_greffe: 3801, date_depot: '20180731',
            nature_archive: 'B-S', confidentiel: 0, date_cloture: '2017-12-31T00:00:00.000Z', numero_gestion: '1994B00001' },
            { id_fichier: 1_810_468, siren: '393463187', denomination_sociale: nil, code_greffe: 3801, date_depot: '20170728',
              nature_archive: 'B-S', confidentiel: 0, date_cloture: '2016-12-31T00:00:00.000Z', numero_gestion: '1994B00001' }
        ]
      }
      expect(response_json).to include expected_json
    end
  end
end
