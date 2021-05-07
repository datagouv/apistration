# frozen_string_literal: true

RSpec.describe "OpenAPI file", type: :acceptance do
  DEFINITION_PATHS = [
    'public/v2/open-api.yml',
    *Dir.glob('swagger/**/*.yaml')
  ].freeze

  DEFINITION_PATHS.each do |definition_path|
    context "OpenAPI definition path: #{definition_path.inspect}" do
      it "is a valid YAML" do
        expect(YAML.load_file(definition_path)).to be_truthy
      end

      it "is a valid OpenAPI configuration" do
        document = Openapi3Parser.load_file(definition_path)
        expect(document).to be_valid, "Errors: #{document.errors.to_h}"
      end
    end
  end
end
