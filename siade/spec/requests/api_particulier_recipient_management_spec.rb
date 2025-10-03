# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'API Particulier: recipient management' do
  subject(:make_request) do
    get url, params:, headers:
  end

  let(:organizer) { double('organizer', success?: false, cacheable: true, errors: [NotFoundError.new('CNAV')]) } # rubocop:disable RSpec/VerifiedDoubles
  let(:siret) { Token.find(yes_jwt_id).siret }
  let(:jwt_token) { JWT.encode({ jti: yes_jwt_id, uid: yes_jwt_id, iat: Time.now.to_i }, Siade.credentials[:jwt_hash_secret], Siade.credentials[:jwt_hash_algo]) }

  before do
    host! 'particulier.api.localtest.me'
    allow(CNAV::QuotientFamilialV2).to receive(:call).and_return(organizer)
  end

  describe 'API v2 (recipient not mandatory)' do
    let(:url) { '/api/v2/composition-familiale-v2' }

    describe 'with QF v2 and civility params' do
      let(:params) { { what: 'ever' } }
      let(:headers) { { 'X-Api-Key' => jwt_token } }

      it 'calls organizer with recipient as siret from token' do
        expect(CNAV::QuotientFamilialV2).to receive(:call).with(
          hash_including(recipient: siret)
        )

        make_request
      end
    end

    describe 'with QF v2 and france connect' do
      let(:headers) { { 'Authorization' => 'Bearer france_connect_token' } }

      before do
        mock_valid_france_connect_checktoken(scopes: Scope.all)
      end

      describe 'when recipient param is present' do
        let(:params) { { recipient: valid_siret } }

        it 'calls organizer with recipient as siret from params' do
          expect(CNAV::QuotientFamilialV2).to receive(:call).with(
            hash_including(recipient: valid_siret)
          )

          make_request
        end
      end

      context 'when recipient param is missing' do
        let(:params) { {} }

        it 'renders 400' do
          make_request

          expect(response).to have_http_status(:bad_request)
        end
      end
    end
  end

  describe 'API v3 (recipient mandatory)' do
    describe 'with QF v2 and civility params' do
      let(:url) { '/v3/dss/quotient_familial/identite' }
      let(:headers) { { 'Authorization' => "Bearer #{jwt_token}" } }

      context 'when recipient param is present' do
        let(:params) { { what: 'ever', recipient: valid_siret } }

        it 'calls organizer with recipient as siret from recipient param' do
          expect(CNAV::QuotientFamilialV2).to receive(:call).with(
            hash_including(recipient: valid_siret)
          )

          make_request
        end
      end

      context 'when recipient param is missing' do
        let(:url) { '/v3/dss/quotient_familial/identite' }
        let(:params) { { what: 'ever' } }

        it 'returns 422 error' do
          make_request

          expect(response).to have_http_status(:unprocessable_content)
        end
      end
    end

    describe 'with QF v2 and franceconnect token' do
      let(:url) { '/v3/dss/quotient_familial/france_connect' }
      let(:headers) { { 'Authorization' => 'Bearer france_connect_token' } }

      before do
        mock_valid_france_connect_checktoken(scopes: Scope.all)
      end

      context 'when recipient param is present' do
        let(:params) { { recipient: valid_siret } }

        it 'calls organizer with recipient as siret from recipient param' do
          expect(CNAV::QuotientFamilialV2).to receive(:call).with(
            hash_including(recipient: valid_siret)
          )

          make_request
        end
      end

      context 'when recipient param is missing' do
        let(:params) { {} }

        it 'returns 422 error' do
          make_request

          expect(response).to have_http_status(:unprocessable_content)
        end
      end
    end
  end
end
