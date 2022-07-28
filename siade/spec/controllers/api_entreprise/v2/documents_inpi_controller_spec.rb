RSpec.describe APIEntreprise::V2::DocumentsINPIController, type: :controller do
  before do
    allow_any_instance_of(SIADE::V2::Requests::INPI::Authenticate)
      .to receive(:cookie)
      .and_return(valid_cookie_inpi)
  end

  it_behaves_like 'unauthorized', :actes
  it_behaves_like 'unprocessable_entity', :actes
  it_behaves_like 'forbidden', :actes
  it_behaves_like 'ask_for_mandatory_parameters', :actes
  context 'when siren not found: #actes', vcr: { cassette_name: 'inpi_actes_not_found' } do
    it_behaves_like 'not_found', siren: not_found_siren(:inpi), action: :actes
  end

  it_behaves_like 'unauthorized', :bilans
  it_behaves_like 'unprocessable_entity', :bilans
  it_behaves_like 'forbidden', :bilans
  it_behaves_like 'ask_for_mandatory_parameters', :bilans
  context 'when siren not found: #bilans', vcr: { cassette_name: 'inpi_bilans_not_found' } do
    it_behaves_like 'not_found', siren: not_found_siren(:inpi), action: :bilans
  end

  shared_examples 'inpi authentication failure' do |action|
    before do
      allow_any_instance_of(SIADE::V2::Requests::INPI::Authenticate)
        .to receive(:cookie).and_return(nil)

      get action, params: { siren: siren, token: yes_jwt }.merge(mandatory_params)
    end

    let(:siren) { valid_siren(:inpi_pdf) }

    it 'returns HTTP code 502' do
      expect(response.status).to eq(502)
    end

    it 'returns an error message' do
      expect(response_json).to have_json_error(detail: "L'authentification auprès du fournisseur de données 'INPI' a échoué")
    end
  end

  describe '#actes' do
    it_behaves_like 'inpi authentication failure', :actes

    context 'with valid siren but invalid documents', vcr: { cassette_name: 'inpi_get_documents_not_found' } do
      before do
        allow_any_instance_of(SIADE::V2::Retrievers::ActesINPI)
          .to receive(:ids_fichiers)
          .and_return(ids_fichiers_inpi_not_found)

        get :actes, params: { siren: siren, token: yes_jwt }.merge(mandatory_params)
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
        get :actes, params: { siren: siren, token: yes_jwt }.merge(mandatory_params)
      end

      let(:siren) { valid_siren :inpi_pdf }

      it 'returns HTTP code 200' do
        expect(response).to have_http_status :ok
      end

      it 'has valid payload' do
        expected_json = {
          url_documents: a_string_starting_with(Siade.credentials[:public_storage_url]).and(a_string_ending_with('-all_documents.zip')),
          actes: [
            { id_fichier: 212_007_233, siren: '393463187', denomination_sociale: nil, code_greffe: 3801, date_depot: '20050112', nature_archive: 'A' },
            { id_fichier: 215_591_165, siren: '393463187', denomination_sociale: nil, code_greffe: 3801, date_depot: '19940103', nature_archive: 'A' },
            { id_fichier: 221_222_958, siren: '393463187', denomination_sociale: nil, code_greffe: 3801, date_depot: '20010723', nature_archive: 'A' }
          ]
        }
        expect(response_json).to include expected_json
      end
    end
  end

  describe '#bilans' do
    it_behaves_like 'inpi authentication failure', :bilans

    context 'with valid siren but invalid documents', vcr: { cassette_name: 'inpi_get_documents_not_found' } do
      before do
        allow_any_instance_of(SIADE::V2::Retrievers::BilansINPI)
          .to receive(:ids_fichiers)
          .and_return(ids_fichiers_inpi_not_found)

        get :bilans, params: { siren: siren, token: yes_jwt }.merge(mandatory_params)
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
        get :bilans, params: { siren: siren, token: yes_jwt }.merge(mandatory_params)
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
end
