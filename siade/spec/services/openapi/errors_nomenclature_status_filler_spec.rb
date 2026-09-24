require 'rails_helper'

RSpec.describe Openapi::ErrorsNomenclatureStatusFiller do
  subject(:fill) { described_class.new(open_api, api: :entreprise).perform }

  let(:path) { '/v3/insee/sirene/etablissements/diffusibles/{siret}' }
  let(:operation_id) { 'api_entreprise_v3_insee_etablissements_diffusables' }
  let(:responses) do
    {
      '200' => { 'description' => 'Success', 'x-operationId' => operation_id },
      '404' => { 'description' => 'Documented by its request spec' }
    }
  end
  let(:open_api) { { 'paths' => { path => { 'get' => { 'responses' => responses } } } } }

  def filled_responses
    open_api.dig('paths', path, 'get', 'responses')
  end

  it 'documents a status the nomenclature lists but the swagger lacks with its first nomenclature example' do
    fill

    expect(filled_responses['451']['description']).to eq('Indisponible pour des raisons légales')
    expect(filled_responses.dig('451', 'content', 'application/json', 'examples').values.first.dig('value', 'errors', 0)).to include(
      'code' => '01005',
      'meta' => { 'provider' => 'INSEE' }
    )
  end

  it 'documents a status only the platform codes carry' do
    fill

    expect(filled_responses.dig('400', 'content', 'application/json', 'examples').values.first.dig('value', 'errors', 0, 'code')).to eq('00401')
  end

  it 'keeps the responses the request specs documented' do
    fill

    expect(filled_responses['404']).to eq('description' => 'Documented by its request spec')
  end

  it 'leaves every nomenclature status documented' do
    fill

    nomenclature = ErrorsNomenclature.new(:entreprise).to_h
    nomenclature_statuses = nomenclature.dig('endpoints', operation_id, 'errors').keys + nomenclature['platform_codes'].keys

    expect(filled_responses.keys).to include(*nomenclature_statuses)
  end

  context 'with an operation outside the nomenclature' do
    let(:operation_id) { 'api_entreprise_v3_not_in_the_nomenclature' }

    it 'leaves it untouched' do
      expect { fill }.not_to change(filled_responses, :keys)
    end
  end
end
