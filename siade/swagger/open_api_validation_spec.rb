require 'spec_helper'

RSpec.describe "OpenAPI v3 file", type: :acceptance do
  let(:open_api_file) { Rails.root.join("swagger/v3/openapi.yaml") }

  it "is a valid YAML" do
    expect {
      YAML.load_file(open_api_file)
    }.not_to raise_error
  end

  it "is a valid OpenAPI configuration" do
    document = Openapi3Parser.load_file(open_api_file)

    expect(document).to be_valid, "Errors: #{document.errors.to_h}"
  end
end
