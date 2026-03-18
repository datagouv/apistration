RSpec.describe API::V2::CertificatsRGEAdemeController do
  it_behaves_like 'unauthorized'
  it_behaves_like 'unprocessable_entity', :show, :siret
  it_behaves_like 'forbidden'
  it_behaves_like 'ask_for_mandatory_parameters'

  context 'siret inconnu chez ADEME', vcr: { cassette_name: 'ademe/rge/with_not_found_siret' } do
    let(:token) { yes_jwt }
    it_behaves_like 'not_found', siret: not_found_siret(:rge_ademe)
  end

  describe '#show' do
    before do
      get :show, params: { siret: siret, token: token }.merge(mandatory_params)
    end

    let(:response_body) do
      JSON.parse(response.body, symbolize_names: true)
    end

    context 'when user authenticate with valid token' do
      let(:token) { yes_jwt }

      context 'siret connu de l\'ADEME', vcr: { cassette_name: 'ademe/rge/with_valid_siret' } do
        let(:siret) { valid_siret(:rge_ademe) }

        subject { response_body }

        it 'returns HTTP code 200'  do
          expect(response).to have_http_status(200)
        end

        its([:qualifications]) do
          is_expected.to include(a_hash_including({
            nom: 'Qualisol - Pose de chauffe-eau solaire individuel (eau chaude solaire)',
            url_certificat: a_string_starting_with(Siade.credentials[:public_storage_url]).and(a_string_ending_with('-certificat_rge_ademe.pdf')),
            nom_certificat: 'Qualisol CESI',
          }))
        end

        its([:domaines]) do
          is_expected.to include('Chauffage et/ou eau chaude solaire')
        end

        context 'when the user doesn\'t want the PDF' do
          before { get :show, params: { siret: siret, token: token, skip_pdf: true }.merge(mandatory_params) }

          its([:qualifications]) do
            is_expected.to include(a_hash_including({
              nom:            'Qualisol - Pose de chauffe-eau solaire individuel (eau chaude solaire)',
              url_certificat: nil,
              nom_certificat: 'Qualisol CESI',
            }))
          end
        end
      end
    end
  end
end
