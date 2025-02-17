RSpec.describe DSNJ::ServiceNational::ValidateNomNaissance, type: :validate_params do
  subject { described_class.call(params: { nom_naissance: }) }

  let(:nom_naissance) { 'ELDENRING' }


  context 'with valid nom_naissance' do
    it { is_expected.to be_a_success }

    its(:errors) { is_expected.to be_empty }
  end

  context 'when nom_naissance is empty' do
    let(:nom_naissance) { '' }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
  end

  context 'when nom_naissance is nil' do
    let(:nom_naissance) { nil }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
  end

  context 'when nom_naissance contains a forbidden character' do
    let(:nom_naissance) { 'Dark Souls 1' }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
  end
end
