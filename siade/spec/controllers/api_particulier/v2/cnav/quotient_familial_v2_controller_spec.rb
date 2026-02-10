require 'rails_helper'

RSpec.describe APIParticulier::V2::CNAV::QuotientFamilialV2Controller do
  describe '#cache_key' do
    subject(:cache_key) { controller.send(:cache_key) }

    let(:request_path) { '/api/v2/composition-familiale-v2' }
    let(:request_params) do
      ActionController::Parameters.new(
        nomUsage: 'DUPONT',
        prenoms: ActionController::Parameters.new(
          weird: 'VALUE',
          nested: [ActionController::Parameters.new(foo: 'BAR')]
        )
      )
    end

    before do
      allow(controller).to receive_messages(
        france_connect?: false,
        request: instance_double(ActionDispatch::Request, path: request_path),
        params: request_params
      )
    end

    it 'builds a stable hashed key with nested parameters' do
      expect { cache_key }.not_to raise_error
      expect(cache_key).to eq(controller.send(:cache_key))
      expect(cache_key).to match(/\A#{Regexp.escape(request_path)}:[0-9a-f]{64}\z/)
    end
  end
end
