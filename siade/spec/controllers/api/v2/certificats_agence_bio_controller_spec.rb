RSpec.describe API::V2::CertificatsAgenceBIOController do
  it_behaves_like 'unauthorized'
  it_behaves_like 'unprocessable_entity', :show, :siret
  it_behaves_like 'forbidden'
  it_behaves_like 'ask_for_mandatory_parameters'

  describe '#show' do
    context 'with valid token' do
      let(:token) { yes_jwt }

      context 'with siret having no active certifications', vcr: { cassette_name: 'agence_bio/with_not_found_siret' } do
        it_behaves_like 'not_found', siret: not_found_siret(:agence_bio)
      end

      context 'with siret having active certifications', vcr: { cassette_name: 'agence_bio/with_valid_siret' } do
        subject { response_json }

        let(:siret) { valid_siret(:agence_bio) }

        before do
          get :show, params: { siret: siret, token: token }.merge(mandatory_params)
        end

        context 'when Agence BIO responds with error' do
          before do
            url = 'https://back.agencebio.org/api/gouv/operateurs'
            stub_request(:get, /#{url}/)
              .to_return(
                status: 500,
                body: 'whatever'
              )

            get :show, params: { siret: siret, token: token }.merge(mandatory_params)
          end

          it 'returns HTTP code 502' do
            expect(response).to have_http_status(:bad_gateway)
          end

          it { is_expected.to have_json_error(detail: 'Mauvaise réponse envoyée par le fournisseur de données') }
        end

        context 'when Agence BIO webserver is UP' do
          it 'returns HTTP code 200' do
            expect(response).to have_http_status(:partial_content)
          end

          it do
            expect(subject).to all(include(
              raison_sociale: String,
              denomination_courante: String,
              siret: String,
              numero_bio: Integer,
              date_derniere_mise_a_jour: String,
              numero_pacage: nil,
              reseau: String,
              categories: a_collection_including(String),
              activites: a_collection_including(String),
              productions: a_collection_including(
                a_hash_including(
                  nom: String,
                  code: String
                )
              ),
              adresses_operateurs: a_collection_including(
                a_hash_including(
                  lieu: String,
                  code_postal: String,
                  ville: String,
                  lat: Float,
                  long: Float,
                  type: a_collection_including(String)
                )
              ),
              certificats: a_collection_including(
                a_hash_including(
                  organisme: String,
                  date_engagement: String,
                  url: String,
                  etat_certification: String,
                  date_arret: nil,
                  date_suspension: nil
                )
              )
            ))
          end
        end
      end
    end
  end
end
