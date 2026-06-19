require 'rails_helper'

RSpec.describe 'GET /open-api.yml' do
  context 'when on API Entreprise' do
    before { host! 'entreprise.api.localtest.me' }

    it 'returns 200' do
      allow(APIEntreprise::OpenAPIDefinition.instance)
        .to receive(:open_api_definition_content)
        .and_return("info:\n  title: Test\npaths: {}\n")

      get '/open-api.yml'

      expect(response).to have_http_status(:ok)
    end

    it 'returns the full definition when no operation_id params are given' do
      allow(APIEntreprise::OpenAPIDefinition.instance)
        .to receive(:open_api_definition_content)
        .and_return("info:\n  title: Full\npaths: {}\n")

      get '/open-api.yml'

      expect(APIEntreprise::OpenAPIDefinition.instance)
        .to have_received(:open_api_definition_content)
      expect(response.body).to eq("info:\n  title: Full\npaths: {}\n")
    end

    it 'passes all operation_ids to the partial service' do
      allow(APIEntreprise::OpenAPIDefinition.instance)
        .to receive(:open_api_partial_definition_content)
        .and_return("info:\n  title: Partial\npaths: {}\n")

      get '/open-api.yml?operation_id[]=op_id_one&operation_id[]=op_id_two'

      expect(APIEntreprise::OpenAPIDefinition.instance)
        .to have_received(:open_api_partial_definition_content)
        .with(%w[op_id_one op_id_two])
    end

    it 'returns the filtered YAML when operation_id params are given' do
      allow(APIEntreprise::OpenAPIDefinition.instance)
        .to receive(:open_api_partial_definition_content)
        .and_return("info:\n  title: Filtered\npaths: {}\n")

      get '/open-api.yml?operation_id[]=op_id_one'

      expect(response.body).to eq("info:\n  title: Filtered\npaths: {}\n")
    end
  end

  context 'when on API Particulier' do
    before { host! 'particulier.api.localtest.me' }

    it 'returns 200' do
      allow(APIParticulier::OpenAPIDefinition.instance)
        .to receive(:open_api_definition_content)
        .and_return("info:\n  title: Test\npaths: {}\n")

      get '/open-api.yml'

      expect(response).to have_http_status(:ok)
    end

    it 'returns the full definition when no operation_id params are given' do
      allow(APIParticulier::OpenAPIDefinition.instance)
        .to receive(:open_api_definition_content)
        .and_return("info:\n  title: Full Particulier\npaths: {}\n")

      get '/open-api.yml'

      expect(APIParticulier::OpenAPIDefinition.instance)
        .to have_received(:open_api_definition_content)
      expect(response.body).to eq("info:\n  title: Full Particulier\npaths: {}\n")
    end

    it 'passes all operation_ids to the partial service' do
      allow(APIParticulier::OpenAPIDefinition.instance)
        .to receive(:open_api_partial_definition_content)
        .and_return("info:\n  title: Partial\npaths: {}\n")

      get '/open-api.yml?operation_id[]=op_id_one&operation_id[]=op_id_two'

      expect(APIParticulier::OpenAPIDefinition.instance)
        .to have_received(:open_api_partial_definition_content)
        .with(%w[op_id_one op_id_two])
    end

    it 'returns the filtered YAML when operation_id params are given' do
      allow(APIParticulier::OpenAPIDefinition.instance)
        .to receive(:open_api_partial_definition_content)
        .and_return("info:\n  title: Filtered Particulier\npaths: {}\n")

      get '/open-api.yml?operation_id[]=op_id_one'

      expect(response.body).to eq("info:\n  title: Filtered Particulier\npaths: {}\n")
    end
  end
end
