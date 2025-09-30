# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MCPController do
  describe 'authentication' do
    subject { post :handle, params:, as: :json }

    let(:params) do
      {
        jsonrpc: '2.0',
        id: 1,
        method: 'tools/list',
        params: {}
      }
    end

    context 'without authorization header' do
      it {
        subject
        expect(response).to have_http_status(:unauthorized)
      }
    end

    context 'with valid authorization header' do
      before { request.headers['Authorization'] = "Bearer #{token}" }

      describe 'with token which has full access (mcp_token)' do
        let(:token) { 'mcp_token' }

        it {
          subject
          expect(response).to have_http_status(:ok)
        }

        it 'renders all tools' do
          subject
          expect(response.parsed_body['result']['tools']).to be_present
          expect(response.parsed_body['result']['tools'].pluck('name')).to include('urssaf/attestations_sociales')
        end
      end

      describe 'with token which is open data only' do
        let(:token) { 'open_data_mcp_token' }

        it {
          subject
          expect(response).to have_http_status(:ok)
        }

        it 'renders only open data tools' do
          subject
          expect(response.parsed_body['result']['tools']).to be_present
          expect(response.parsed_body['result']['tools'].pluck('name')).not_to include('urssaf/attestations_sociales')
        end
      end
    end
  end

  describe 'tools calling' do
    subject { post :handle, params:, as: :json }

    let(:params) do
      mcp_params.merge(
        'jsonrpc' => '2.0',
        'id' => 7,
        'mcp' => mcp_params.merge(
          'jsonrpc' => '2.0',
          'id' => 7
        )
      )
    end

    let(:mcp_params) do
      {
        'method' => 'tools/call',
        'params' => {
          'name' => 'insee/unite_legale',
          'arguments' => {
            'siren' => '130025265'
          }
        }
      }
    end

    let(:request_id) { SecureRandom.uuid }

    before do
      request.headers['Authorization'] = 'Bearer mcp_token'
      allow_any_instance_of(ActionController::TestRequest).to receive(:request_id).and_return(request_id) # rubocop:disable RSpec/AnyInstance
    end

    it 'calls the tool with context which includes request_id' do
      expect(INSEE::UniteLegaleTool).to receive(:call).with(
        siren: '130025265',
        server_context: hash_including(request_id: request_id)
      )

      subject
    end
  end
end
