RSpec.describe ADEME::ValidateLimit, type: :validate_param_interactor do
  subject { described_class.call(params:) }

  let(:params) do
    { limit: }
  end

  context 'when over 10_000' do
    let(:limit) { 10_001 }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to be_present }
  end

  context 'when under 0' do
    let(:limit) { -1 }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to be_present }
  end

  context 'when between 0 and 10_000' do
    let(:limit)  { 100 }

    it { is_expected.to be_a_success }
  end
end
