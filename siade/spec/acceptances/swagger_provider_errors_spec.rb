RSpec.describe 'Swagger provider errors', type: :acceptance do
  let(:openapi) { YAML.load_file(Rails.root.join('swagger/openapi-particulier.yaml'), aliases: true) }

  def bad_gateway_codes(path)
    openapi
      .dig('paths', path, 'get', 'responses', '502', 'content', 'application/json', 'examples')
      .values
      .map { |example| example.dig('value', 'errors', 0, 'code') }
  end

  it 'documents a prestation sociale under the prefix of the Sécurité sociale' do
    expect(bad_gateway_codes('/v3/dss/prime_activite/identite')).to include('36000')
  end

  it 'documents the quotient familial under the prefix of the CNAF & MSA' do
    expect(bad_gateway_codes('/v3/dss/quotient_familial/identite')).to include('35000')
  end
end
