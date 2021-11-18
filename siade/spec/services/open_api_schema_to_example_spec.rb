RSpec.describe OpenAPISchemaToExample do
  subject(:stubbed_json) { described_class.new(schema.deep_stringify_keys).perform }

  describe 'array item' do
    let(:schema) do
      {
        type: 'array',
        items: {
          type: 'string',
          example: 'example value'
        }
      }
    end

    it { is_expected.to eq(['example value']) }
  end

  describe 'object item' do
    let(:schema) do
      {
        type: 'object',
        properties: {
          my_object_name: {
            type: 'string',
            example: 'example value'
          }
        }
      }
    end

    it { is_expected.to eq({ 'my_object_name' => 'example value' }) }
  end

  describe 'string item' do
    let(:schema) do
      {
        type: 'string',
        example: 'example value'
      }
    end

    it { is_expected.to eq('example value') }
  end

  describe 'integer item' do
    let(:schema) do
      {
        type: 'integer',
        example: 9000
      }
    end

    it { is_expected.to eq(9000) }
  end

  describe 'boolean item' do
    let(:schema) do
      {
        type: 'boolean',
        example: true
      }
    end

    it { is_expected.to be true }
  end

  describe 'unknown type item' do
    let(:schema) do
      {
        type: 'unknown',
        example: 'useless'
      }
    end

    it 'raise an error when invalid type found' do
      expect { stubbed_json }.to raise_error(OpenAPISchemaToExample::InvalidOpenAPIType, '{"type"=>"unknown", "example"=>"useless"}')
    end
  end
end
