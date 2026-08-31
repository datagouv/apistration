RSpec.describe CNAV::QuotientFamilialV2::ValidatePeriod, type: :validate_param_interactor do
  subject { described_class.call(params: { mois:, annee: }) }

  context 'when both mois and annee are given' do
    let(:mois) { 8 }
    let(:annee) { 2024 }

    it { is_expected.to be_a_success }
  end

  context 'when neither mois nor annee is given' do
    let(:mois) { nil }
    let(:annee) { nil }

    it { is_expected.to be_a_success }
  end

  shared_examples 'half a period' do
    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }

    it 'tells the caller both parameters go together' do
      expect(subject.errors.first.code).to eq('00357')
    end
  end

  context 'when only mois is given' do
    let(:mois) { 8 }
    let(:annee) { nil }

    it_behaves_like 'half a period'
  end

  context 'when only annee is given' do
    let(:mois) { nil }
    let(:annee) { 2024 }

    it_behaves_like 'half a period'
  end

  context 'when mois is blank' do
    let(:mois) { '' }
    let(:annee) { 2024 }

    it_behaves_like 'half a period'
  end
end
