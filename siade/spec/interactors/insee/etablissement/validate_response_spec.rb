RSpec.describe INSEE::Etablissement::ValidateResponse, type: :validate_response do
  subject { described_class.call(response:, provider_name: 'INSEE') }

  it 'behaves like INSEE::UniteLegale::ValidateResponse' do
    expect(described_class).to be < INSEE::UniteLegale::ValidateResponse
  end

  context 'with a forbidden error' do
    let(:response) { instance_double(Net::HTTPForbidden, code: '403') }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(UnavailableForLegalReasonsError)) }

    it 'names the siret as the protected entity' do
      expect(subject.errors.first.detail).to eq('Le siret demandé est une entité pour laquelle aucun organisme ne peut avoir accès.')
    end
  end
end
