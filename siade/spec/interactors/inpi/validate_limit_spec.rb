RSpec.describe INPI::ValidateLimit, type: :validate_param_interactor do
  subject { described_class.call(params: params) }

  let(:params) do
    { limit: limit }
  end

  context 'when over 20' do
    let(:limit) { 21 }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to be_present }
  end

  context 'when under 0' do
    let(:limit) { -1 }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to be_present }
  end

  context 'when between 0 and 20' do
    let(:limit)  { 10 }

    it { is_expected.to be_a_success }
  end
end
