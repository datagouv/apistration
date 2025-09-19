# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MCPController do
  describe 'GET #handle' do
    subject { get :handle }

    context 'without authorization header' do
      it {
        subject
        expect(response).to have_http_status(:unauthorized)
      }
    end

    context 'with valid authorization header' do
      before { request.headers['Authorization'] = 'Bearer mcp_token' }

      it {
        subject
        expect(response).to have_http_status(:ok)
      }
    end
  end
end
