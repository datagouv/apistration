# frozen_string_literal: true

require 'rails_helper'

RSpec.describe APIParticulierController, 'france connectable' do
  # rubocop:enable RSpec/DescribeMethod

  controller(described_class) do
    include APIParticulier::FranceConnectable

    def show
      # rubocop:disable Style/OpenStructUse
      organizer = OpenStruct.new(
        provider_name: 'dummy',
        errors: [UnprocessableEntityError.new(:gender)]
      )
      # rubocop:enable Style/OpenStructUse

      if params[:test_invalid_params]
        render_errors(organizer)
      else
        render json: france_connect_service_user_identity.to_h,
          status: :ok
      end
    end
  end

  let(:token) { 'token' }

  describe 'with a bearer token' do
    subject(:make_call) do
      routes.draw { get 'show' => 'api_particulier#show' }

      request.headers['Authorization'] = "Bearer #{token}"

      get :show, params:
    end

    let(:params) { {} }

    context 'when it is not a valid france connect token' do
      before do
        mock_invalid_france_connect_checktoken(kind)
      end

      context 'when it is expired or not found' do
        let(:kind) { :expired_or_not_found }

        its(:status) { is_expected.to eq(401) }
      end

      context 'when it is malformed' do
        let(:kind) { :malformed }

        its(:status) { is_expected.to eq(401) }
      end
    end

    context 'when it is a valid france connect token' do
      before do
        mock_valid_france_connect_checktoken(scopes: %w[openid identite_pivot].concat(scopes))
      end

      context 'when built token has valid scope' do
        let(:scopes) { %w[allowed_scope] }

        its(:status) { is_expected.to eq(200) }

        it 'affects person attributes in controller context' do
          expect(make_call.body).to eq(default_france_connect_identity_attributes.to_json)
        end

        context 'when organizer has errors' do
          let(:params) { { test_invalid_params: true } }

          its(:status) { is_expected.to eq(400) }

          it 'tracks errors' do
            expect(MonitoringService.instance).to receive(:track).with(
              'error',
              /Invalid params with FranceConnect/,
              anything
            )

            make_call
          end
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
