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
end
