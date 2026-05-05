# frozen_string_literal: true

require 'rails_helper'

RSpec.describe APIParticulier::OpenAPIController do
  describe 'GET #show' do
    context 'without a provider param' do
      before { get :show }

      it { expect(response).to have_http_status(:success) }

      it 'serves the full V3 OpenAPI document' do
        parsed = YAML.safe_load(response.body, aliases: true, permitted_classes: [Date])

        expect(parsed['paths']).not_to be_empty
        expect(parsed['openapi']).to start_with('3.')
      end

      it 'sets the application/x-yaml content type' do
        expect(response.media_type).to eq('application/x-yaml')
      end
    end

    context 'with a known provider' do
      before { get :show, params: { provider: 'cnous' } }

      it { expect(response).to have_http_status(:success) }

      it 'restricts paths to that provider' do
        parsed = YAML.safe_load(response.body, aliases: true, permitted_classes: [Date])

        expect(parsed['paths'].keys).to all(match(%r{\A/v\d+/cnous/}))
        expect(parsed['paths']).not_to be_empty
      end
    end

    context 'with an unknown provider' do
      before { get :show, params: { provider: 'nonexistent_provider' } }

      it { expect(response).to have_http_status(:success) }

      it 'returns an OpenAPI document with empty paths' do
        parsed = YAML.safe_load(response.body, aliases: true, permitted_classes: [Date])

        expect(parsed['paths']).to eq({})
      end
    end
  end
end
