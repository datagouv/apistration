RSpec.describe 'API Particulier: birth commune deduced from its name (transcogage)', api: :particulier do
  subject(:call_endpoint) do
    get path, params:, headers: { 'Authorization' => "Bearer #{yes_jwt}" }
  end

  let(:civility_params) do
    {
      recipient: valid_siret,
      context: 'test',
      object: 'test',
      nomNaissance: 'Dupont',
      prenoms: %w[Jean],
      anneeDateNaissance: '2000',
      moisDateNaissance: '01',
      jourDateNaissance: '01',
      sexeEtatCivil: 'M',
      nomCommuneNaissance: 'Gennevilliers',
      codeCogInseeDepartementNaissance: '92'
    }
  end

  let(:insee_communes_url) { "#{Siade.credentials[:insee_metadata_url]}/geo/communes" }

  shared_examples 'an endpoint deducing the birth commune from its name' do
    context 'when INSEE finds the commune' do
      before do
        stub_request(:get, /#{insee_communes_url}/).to_return(
          status: 200,
          body: [{ code: '92036', intitule: 'Gennevilliers' }].to_json
        )
      end

      it 'searches the student with the commune code found by INSEE' do
        call_endpoint

        expect(response).to have_http_status(:ok)
        expect(provider_request.with(body: /92036/)).to have_been_made
      end
    end

    context 'when INSEE finds no commune with this name in the departement' do
      before do
        stub_request(:get, /#{insee_communes_url}/).to_return(
          status: 200,
          body: [{ code: '33001', intitule: 'Gennevilliers' }, { code: '45001', intitule: 'Gennevilliers' }].to_json
        )
      end

      it 'returns the INSEE error without searching the student' do
        call_endpoint

        expect(response).to have_http_status(:not_found)
        expect(response_json[:errors].first[:code]).to eq(NotFoundError.new('INSEE', 'irrelevant').code)
        expect(provider_request).not_to have_been_made
      end
    end

    context 'when INSEE is unavailable' do
      before do
        stub_request(:get, /#{insee_communes_url}/).to_return(status: 500, body: '')
      end

      it 'returns the INSEE error without searching the student' do
        call_endpoint

        expect(response).to have_http_status(:bad_gateway)
        expect(response_json[:errors].first[:code]).to eq(ProviderInternalServerError.new('INSEE').code)
        expect(provider_request).not_to have_been_made
      end
    end

    context 'when the other civility params are invalid' do
      let(:params) { civility_params.merge(nomNaissance: '123') }

      before do
        stub_request(:get, /#{insee_communes_url}/).to_return(status: 500, body: '')
      end

      it 'returns the civility error without querying INSEE' do
        call_endpoint

        expect(response).to have_http_status(:unprocessable_content)
        expect(response_json[:errors].pluck(:code)).to eq([UnprocessableEntityError.new(:nom_naissance).code])
        expect(a_request(:get, /#{insee_communes_url}/)).not_to have_been_made
      end
    end
  end

  describe 'MESRI student status' do
    let(:path) { '/v3/mesri/statut_etudiant/identite' }
    let(:params) { civility_params }
    let(:provider_request) { a_request(:post, /#{Siade.credentials[:mesri_student_status_url]}/) }

    before { stub_mesri_with_civility_valid }

    it_behaves_like 'an endpoint deducing the birth commune from its name'
  end

  describe 'CNOUS student scholarship' do
    let(:path) { '/v5/cnous/etudiant_boursier/identite' }
    let(:params) { civility_params }
    let(:provider_request) { a_request(:post, /#{Siade.credentials[:cnous_student_scholarship_civility_url]}/) }

    before do
      mock_cnous_authenticate
      mock_cnous_valid_call('civility')
    end

    it_behaves_like 'an endpoint deducing the birth commune from its name'
  end
end
