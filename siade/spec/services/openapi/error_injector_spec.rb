require 'rails_helper'

RSpec.describe Openapi::ErrorInjector do
  let(:config_path) { Rails.root.join('config/openapi_common_errors/entreprise.yml') }

  describe '#perform' do
    context 'with a route that has a provider' do
      let(:open_api) do
        {
          'paths' => {
            '/v3/insee/sirene/unites_legales/{siren}' => {
              'get' => {
                'responses' => {
                  '200' => { 'description' => 'Success' }
                }
              }
            }
          }
        }
      end

      it 'injects all error responses' do
        described_class.new(open_api, config_path:).perform

        responses = open_api.dig('paths', '/v3/insee/sirene/unites_legales/{siren}', 'get', 'responses')

        expect(responses).to have_key('401')
        expect(responses).to have_key('403')
        expect(responses).to have_key('409')
        expect(responses).to have_key('422')
        expect(responses).to have_key('429')
        expect(responses).to have_key('502')
        expect(responses).to have_key('504')
      end

      it 'produces valid example structure for 401' do
        described_class.new(open_api, config_path:).perform

        examples = open_api.dig(
          'paths', '/v3/insee/sirene/unites_legales/{siren}', 'get', 'responses',
          '401', 'content', 'application/json', 'examples'
        )

        expect(examples.keys).to eq(['invalid_token_error'])

        token_error = examples['invalid_token_error']
        expect(token_error['value']['errors'].first['code']).to eq('00101')
        expect(token_error).to have_key('summary')
        expect(token_error).to have_key('description')
      end

      it 'documents a single 422 example' do
        described_class.new(open_api, config_path:).perform

        examples = open_api.dig(
          'paths', '/v3/insee/sirene/unites_legales/{siren}', 'get', 'responses',
          '422', 'content', 'application/json', 'examples'
        )

        expect(examples.keys).to eq(['missing_mandatory_param_error'])
        expect(examples.dig('missing_mandatory_param_error', 'value', 'errors', 0, 'code')).to eq('00203')
      end

      it 'uses provider name in 502/504 examples' do
        described_class.new(open_api, config_path:).perform

        examples_502 = open_api.dig(
          'paths', '/v3/insee/sirene/unites_legales/{siren}', 'get', 'responses',
          '502', 'content', 'application/json', 'examples'
        )

        provider_meta = examples_502.dig('provider_unknown_error', 'value', 'errors', 0, 'meta', 'provider')
        expect(provider_meta).to eq('INSEE')
      end
    end

    context 'with a route without provider (e.g. /privileges)' do
      let(:open_api) do
        {
          'paths' => {
            '/privileges' => {
              'get' => {
                'responses' => {
                  '200' => { 'description' => 'Success' }
                }
              }
            }
          }
        }
      end

      it 'skips 502 and 504' do
        described_class.new(open_api, config_path:).perform

        responses = open_api.dig('paths', '/privileges', 'get', 'responses')

        expect(responses).not_to have_key('502')
        expect(responses).not_to have_key('504')
      end

      it 'still injects 401, 403, 409, 429' do
        described_class.new(open_api, config_path:).perform

        responses = open_api.dig('paths', '/privileges', 'get', 'responses')

        expect(responses).to have_key('401')
        expect(responses).to have_key('403')
        expect(responses).to have_key('409')
        expect(responses).to have_key('429')
      end
    end

    context 'when a response already exists' do
      let(:open_api) do
        {
          'paths' => {
            '/v3/insee/sirene/unites_legales/{siren}' => {
              'get' => {
                'responses' => {
                  '200' => { 'description' => 'Success' },
                  '401' => { 'description' => 'Custom 401' }
                }
              }
            }
          }
        }
      end

      it 'does not overwrite existing responses' do
        described_class.new(open_api, config_path:).perform

        response_401 = open_api.dig('paths', '/v3/insee/sirene/unites_legales/{siren}', 'get', 'responses', '401')
        expect(response_401['description']).to eq('Custom 401')
      end
    end

    context 'with particulier config' do
      let(:config_path) { Rails.root.join('config/openapi_common_errors/particulier.yml') }

      let(:open_api) do
        {
          'paths' => {
            '/v3/dss/allocation_adulte_handicape/identite' => {
              'get' => {
                'responses' => {
                  '200' => { 'description' => 'Success' }
                }
              }
            }
          }
        }
      end

      it 'points at the API Particulier introspection route in the insufficient privileges example' do
        described_class.new(open_api, config_path:).perform

        examples = open_api.dig(
          'paths', '/v3/dss/allocation_adulte_handicape/identite', 'get', 'responses',
          '403', 'content', 'application/json', 'examples'
        )

        expect(examples.dig('insufficient_privileges_error', 'description')).to include('/api/introspect')
      end
    end
  end
end
