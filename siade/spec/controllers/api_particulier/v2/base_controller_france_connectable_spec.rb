# frozen_string_literal: true

require 'rails_helper'

RSpec.describe APIParticulier::V2::BaseController, 'france connectable' do
  # rubocop:enable RSpec/DescribeMethod

  controller(described_class) do
    include APIParticulier::FranceConnectable

    def show
      organizer = OpenStruct.new(
        provider_name: 'dummy',
        errors: []
      )

      if params[:test_invalid_franceconnect_params]
        organizer.errors = [UnprocessableEntityError.new(:gender)]
        render_errors(organizer)
      elsif params[:test_invalid_recipient]
        organizer.errors = [InvalidRecipientError.new]
        render_errors(organizer)
      else
        render json: france_connect_service_user_identity.to_h,
          status: :ok
      end
    end
  end

  let(:token) { 'token' }

  before do
    allow(Siade.credentials).to receive(:[]).and_call_original
    allow(Siade.credentials).to receive(:[]).with(:france_connect_v2_base_client_id).and_return('345')
    allow(Siade.credentials).to receive(:[]).with(:france_connect_v2_base_client_secret).and_return('345')
  end

  describe 'with a bearer token' do
    subject(:make_call) do
      routes.draw { get 'show' => 'api_particulier/v2/base#show' }

      request.headers['Authorization'] = "Bearer #{token}"

      get :show, params:
    end

    let(:recipient) { valid_siret(:recipient) }
    let(:params) { { recipient:, api_version: 3 } }

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
          JSON.parse(make_call.body).each do |key, value|
            expect(value).to eq(default_france_connect_identity_attributes[key.to_sym])
          end
        end

        context 'when organizer has invalid FranceConnect params error' do
          let(:params) { { test_invalid_franceconnect_params: true, recipient:, api_version: 3 } }

          its(:status) { is_expected.to eq(400) }
        end

        context 'when organizer has invalid non-FranceConnect params error' do
          let(:params) { { test_invalid_recipient: true, api_version: 3 } }

          its(:status) { is_expected.to eq(400) }

          it 'does not tracks errors' do
            expect(MonitoringService.instance).not_to receive(:track)

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
