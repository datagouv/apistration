# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable RSpec/DescribeMethod
RSpec.describe APIParticulierController, 'france connectable', type: :controller do
  # rubocop:enable RSpec/DescribeMethod

  controller(described_class) do
    include APIParticulier::FranceConnectable

    def show
      authorize :dummy

      render json: france_connect_service_user_identity.to_h,
        status: :ok
    end
  end

  let(:token) { 'token' }

  describe 'with a bearer token' do
    subject(:make_call) do
      routes.draw { get 'show' => 'api_particulier#show' }

      request.headers['Authorization'] = "Bearer #{token}"

      get :show
    end

    context 'when it is not a valid france connect token' do
      before do
        mock_invalid_france_connect_checktoken
      end

      its(:status) { is_expected.to eq(401) }
    end

    context 'when it is a valid france connect token' do
      before do
        mock_valid_france_connect_checktoken(scopes: %w[openid identite_pivot].concat(scopes))
      end

      context 'when built token has valid scope' do
        let(:scopes) { %w[dummy] }

        its(:status) { is_expected.to eq(200) }

        it 'affects person attributes in controller context' do
          expect(make_call.body).to eq(default_france_connect_identity_attributes.to_json)
        end
      end

      context 'when built token has invalid scope' do
        let(:scopes) { %w[invalid] }

        its(:status) { is_expected.to eq(401) }

        its(:body) do
          is_expected.to include('access_denied')
        end
      end
    end
  end
end
