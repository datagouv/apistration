RSpec.describe CNAV::ValidateSexeEtatCivil, type: :validate_params do
  subject { described_class.call(params: { sexe_etat_civil: }) }

  let(:sexe_etat_civil) { 'F' }

  context 'with valid sexe_etat_civil' do
    it { is_expected.to be_a_success }

    its(:errors) { is_expected.to be_empty }
  end

  context 'when sexe_etat_civil is empty' do
    let(:sexe_etat_civil) { nil }

    it { is_expected.to be_a_success }

    its(:errors) { is_expected.to be_empty }
  end

  context 'when sexe_etat_civil is not valid' do
    let(:sexe_etat_civil) { 'nope' }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
  end
end
