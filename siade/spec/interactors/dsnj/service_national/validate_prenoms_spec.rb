RSpec.describe DSNJ::ServiceNational::ValidatePrenoms, type: :validate_params do
  subject { described_class.call(params: { prenoms: }) }

  let(:prenoms) { %w[Loic Samuel Thomas] }


  context 'with valid prenoms' do
    it { is_expected.to be_a_success }

    its(:errors) { is_expected.to be_empty }
  end

  context 'when prenoms is empty' do
    let(:prenoms) { [] }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
  end

  context 'when prenoms is nil' do
    let(:prenoms) { nil }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
  end

  context 'when prenoms contains a forbidden character' do
    let(:prenoms) { ['François 1er'] }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
  end
end
