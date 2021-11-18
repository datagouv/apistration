RSpec.describe INSEE::Etablissement::ValidateResponse, type: :validate_response do
  it 'behaves like INSEE::UniteLegale::ValidateResponse' do
    expect(described_class).to be < INSEE::UniteLegale::ValidateResponse
  end
end
