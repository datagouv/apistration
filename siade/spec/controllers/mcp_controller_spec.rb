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

      let(:token) { TokenFactory.new(%w[mcp_scope1 mcp_scope2]).valid(mcp: true) }

      it {
        subject
        expect(response).to have_http_status(:ok)
      }

      it 'renders all tools' do
        subject
        expect(response.parsed_body['result']['tools']).to be_present
        expect(response.parsed_body['result']['tools'].pluck('name')).to include('urssaf/attestations_sociales')
        expect(response.parsed_body['result']['tools'].pluck('name')).to include('insee/unite_legale')
        expect(response.parsed_body['result']['tools'].pluck('name')).not_to include('infogreffe/extraits_rcs')
      end
    end

    describe 'with expired token' do
      before { request.headers['Authorization'] = "Bearer #{token}" }

      let(:token) { TokenFactory.new(%w[mcp_scope1 mcp_scope2]).expired }

      it {
        subject
        expect(response).to have_http_status(:unauthorized)
      }
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

    before do
      request.headers['Authorization'] = "Bearer #{token}"
    end

    describe 'tool access' do
      context 'when user has no scope for the tool' do
        let(:token) { TokenFactory.new(%w[mcp_scope2]).valid(mcp: true) }

        it {
          subject
          expect(response).to have_http_status(:unauthorized)
        }
      end

      context 'when user has at least one scope for the tool' do
        context 'when mcp is enabled on token' do
          let(:token) { TokenFactory.new(%w[mcp_scope1]).valid(mcp: true) }

          it {
            subject
            expect(response).to have_http_status(:ok)
          }
        end

        context 'when mcp is not enabled on token' do
          let(:token) { TokenFactory.new(%w[mcp_scope1]).valid(mcp: false) }

          it {
            subject
            expect(response).to have_http_status(:unauthorized)
          }
        end
      end
    end

    describe 'server context' do
      let(:token) { TokenFactory.new(%w[mcp_scope1]).valid(mcp: true) }
      let(:request_id) { SecureRandom.uuid }

      before do
        allow_any_instance_of(ActionController::TestRequest).to receive(:request_id).and_return(request_id) # rubocop:disable RSpec/AnyInstance
      end

      it 'calls the tool with context which includes request_id and user_id' do
        expect(INSEE::UniteLegaleTool).to receive(:call).with(
          siren: '130025265',
          server_context: hash_including(
            request_id: request_id,
            user_id: '00000000-0000-0000-0000-000000000000'
          )
        )

        subject
      end
    end
  end
end
