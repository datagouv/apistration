require 'rails_helper'

RSpec.describe APIParticulier::V2::BaseController, 'recipient' do
  controller(described_class) do
    def index
      render json: { data: true }, status: :ok
    end
  end

  before do
    get :index, params: { api_version: 42, token: yes_jwt }
                    .merge(recipient:)
  end

  context 'with valid siret as recipient' do
    let(:recipient) { valid_siret(:recipient) }

    its(:status) { is_expected.to be(200) }
  end

  context 'with no recipient' do
    let(:recipient) { nil }

    its(:status) { is_expected.to be(200) }
  end

  context 'with invalid value as recipient' do
    let(:recipient) { 'invalid' }

    its(:status) { is_expected.to be(400) }

    it 'serializes an error' do
      expect(response_json).to have_key(:error)
    end
  end
end
