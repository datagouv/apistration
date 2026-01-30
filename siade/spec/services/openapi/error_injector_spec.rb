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

        expect(examples).to have_key('invalid_token_error')
        expect(examples).to have_key('expired_token_error')
        expect(examples).to have_key('blacklisted_token_error')

        token_error = examples['invalid_token_error']
        expect(token_error['value']['errors'].first['code']).to eq('00101')
        expect(token_error).to have_key('summary')
        expect(token_error).to have_key('description')
      end

      it 'includes siren in 422 path params' do
        described_class.new(open_api, config_path:).perform

        examples = open_api.dig(
          'paths', '/v3/insee/sirene/unites_legales/{siren}', 'get', 'responses',
          '422', 'content', 'application/json', 'examples'
        )

        expect(examples).to have_key('unprocessable_content_error_siren_error')
        expect(examples).to have_key('missing_mandatory_params_context_error')
        expect(examples).to have_key('missing_mandatory_params_object_error')
        expect(examples).to have_key('missing_mandatory_params_recipient_error')
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

    context 'when 422 already exists (merge)' do
      let(:open_api) do
        {
          'paths' => {
            '/v3/insee/sirene/unites_legales/{siren}' => {
              'get' => {
                'responses' => {
                  '200' => { 'description' => 'Success' },
                  '422' => {
                    'description' => 'Existing 422',
                    'content' => {
                      'application/json' => {
                        'examples' => {
                          'custom_error' => { 'value' => { 'errors' => [] } }
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      end

      it 'merges 422 examples without overwriting existing ones' do
        described_class.new(open_api, config_path:).perform

        examples = open_api.dig(
          'paths', '/v3/insee/sirene/unites_legales/{siren}', 'get', 'responses',
          '422', 'content', 'application/json', 'examples'
        )

        expect(examples).to have_key('custom_error')
        expect(examples).to have_key('missing_mandatory_params_context_error')
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

      it 'uses particulier mandatory params (only recipient)' do
        described_class.new(open_api, config_path:).perform

        examples = open_api.dig(
          'paths', '/v3/dss/allocation_adulte_handicape/identite', 'get', 'responses',
          '422', 'content', 'application/json', 'examples'
        )

        expect(examples).to have_key('missing_mandatory_params_recipient_error')
        expect(examples).not_to have_key('missing_mandatory_params_context_error')
        expect(examples).not_to have_key('missing_mandatory_params_object_error')
      end
    end
  end
end
