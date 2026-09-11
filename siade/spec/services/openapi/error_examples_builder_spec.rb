require 'rails_helper'

RSpec.describe Openapi::ErrorExamplesBuilder do
  subject(:builder) { described_class.new }

  describe '#build_from_error' do
    it 'returns a hash with the error example keyed by name' do
      error = InvalidTokenError.new
      result = builder.build_from_error(error, 'invalid_token_error')

      expect(result).to have_key('invalid_token_error')
      example = result['invalid_token_error']
      expect(example['summary']).to eq(error.title)
      expect(example['description']).to eq(error.detail)
      expect(example['value']['errors']).to be_an(Array)
      expect(example['value']['errors'].first['code']).to eq('00101')
    end
  end
end
