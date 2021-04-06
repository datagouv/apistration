require 'rails_helper'

RSpec.describe API::V3::PROBTP::AttestationsCotisationRetraiteController, type: :controller do
  it_behaves_like 'unauthorized'
  it_behaves_like 'forbidden'
  it_behaves_like 'ask_for_mandatory_parameters'

  describe '#show' do
    before do
      get :show, params: { siret: siret, token: token }.merge(mandatory_params)
    end

    context 'when user authenticate with valid token', vcr: { cassette_name: 'probtp/attestation/with_eligible_siret' } do
      let(:token) { yes_jwt }

      xcontext 'with invalid siret' do
        let(:siret) { invalid_siret }

        its(:status) { is_expected.to eq(422) }

        it 'returns an error message' do
          expect(response_json).to include({
            errors: ['Le numéro siret indiqué n\'est pas correctement formatté']
          })
        end
      end

      context 'with eligible siret', vcr: { cassette_name: 'probtp/attestation/with_eligible_siret' } do
        let(:siret) { eligible_siret(:probtp) }

        it 'returns HTTP code 200'  do
          expect(response).to have_http_status(200)
        end

        it 'returns a vaild payload' do
          payload = response_json[:data]

          expect(payload).to include(
            id: siret,
            type: 'attestation',
            attributes: a_hash_including(
              :document_url
            )
          )
        end
      end
    end
  end
end
