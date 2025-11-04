require 'rails_helper'

RSpec.describe APIParticulier::V3AndMore::CNAV::AbstractCivilityController do
  controller(described_class) do
    def organizer_class
      CNAV::ValidateParams
    end

    def organizer_params
      api_params.merge({ request_id: SecureRandom.uuid })
    end

    def serializer_class
      Class.new do
        def initialize(_what, _ever); end

        def serializable_hash
          { data: { success: true } }
        end
      end
    end
  end

  subject do
    routes.draw { get 'show/:api_version' => 'api_particulier/v3_and_more/cnav/abstract_civility#show' }

    request.headers['Authorization'] = "Bearer #{token}"
    request.headers['Content-Type'] = 'application/json'

    get :show, params: params.merge(api_version: '3')
  end

  let(:recipient) { valid_siret }
  let(:token) { yes_jwt }

  describe '#show' do
    context 'with valid params without transcogage' do
      let(:params) do
        {
          recipient:,
          nomNaissance: 'DUPONT',
          prenoms: %w[MARIE CLAIRE],
          anneeDateNaissance: '1990',
          moisDateNaissance: '03',
          jourDateNaissance: '15',
          sexeEtatCivil: 'F',
          codeCogInseePaysNaissance: '99123',
          codeCogInseeCommuneNaissance: '75056'
        }
      end

      it 'returns 200' do
        subject

        expect(response).to have_http_status(:ok)
      end
    end

    context 'with valid params with transcogage' do
      let(:params) do
        {
          recipient:,
          nomNaissance: 'MARTIN',
          prenoms: %w[JEAN PAUL],
          anneeDateNaissance: '1985',
          moisDateNaissance: '07',
          jourDateNaissance: '22',
          sexeEtatCivil: 'M',
          nomCommuneNaissance: 'LYON',
          codeCogInseePaysNaissance: '99100',
          codeCogInseeDepartementNaissance: '69'
        }
      end

      it 'returns 200' do
        subject

        expect(response).to have_http_status(:ok)
      end
    end

    context 'with missing required param for transcogage (departement naissance)' do
      let(:params) do
        {
          recipient:,
          nomNaissance: 'BERNARD',
          prenoms: %w[SOPHIE ANNE],
          anneeDateNaissance: '1988',
          moisDateNaissance: '11',
          jourDateNaissance: '05',
          sexeEtatCivil: 'F',
          nomCommuneNaissance: 'MARSEILLE',
          codeCogInseePaysNaissance: '99100'
        }
      end

      it 'returns 422' do
        subject

        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end
end
