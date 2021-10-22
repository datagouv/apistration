RSpec.describe INSEE::Etablissement::ValidateResponse, type: :validate_response do
  it 'behaves like INSEE::Entreprise::ValidateResponse' do
    expect(described_class).to be < INSEE::Entreprise::ValidateResponse
  end
end
