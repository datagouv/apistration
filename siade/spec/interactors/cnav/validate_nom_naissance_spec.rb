RSpec.describe CNAV::ValidateNomNaissance, type: :validate_param_interactor do
  subject do
    described_class.call(params: {
      nom_naissance:
    })
  end

  context 'when nom_naissance is not empty' do
    let(:nom_naissance) { 'Bulbizare' }

    it { is_expected.to be_a_success }

    its(:errors) { is_expected.to be_empty }
  end

  context 'when nom_naissance is nil' do
    let(:nom_naissance) { nil }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
  end
end
