require 'rails_helper'

RSpec.describe Openapi::ErrorsNomenclatureLinker do
  subject(:link) { described_class.new(open_api, api: :entreprise).perform }

  let(:path) { '/v3/insee/sirene/etablissements/diffusibles/{siret}' }
  let(:operation_id) { 'api_entreprise_v3_insee_etablissements_diffusables' }
  let(:open_api) do
    {
      'paths' => {
        path => {
          'get' => {
            'responses' => {
              '200' => { 'description' => 'Success', 'x-operationId' => operation_id },
              '404' => { 'description' => 'Établissement non trouvé' }
            }
          }
        }
      }
    }
  end

  def not_found_description
    open_api.dig('paths', path, 'get', 'responses', '404', 'description')
  end

  it 'links each error response to the full list of the operation errors' do
    link

    expect(not_found_description).to start_with('Établissement non trouvé')
    expect(not_found_description).to include("https://entreprise.api.gouv.fr/errors?operation_id=#{operation_id}")
  end

  it 'leaves the 200 response untouched' do
    link

    expect(open_api.dig('paths', path, 'get', 'responses', '200', 'description')).to eq('Success')
  end

  it 'links an already linked response only once' do
    link
    described_class.new(open_api, api: :entreprise).perform

    expect(not_found_description.scan('operation_id=').size).to eq(1)
  end
end
