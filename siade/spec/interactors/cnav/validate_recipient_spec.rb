RSpec.describe CNAV::ValidateRecipient, type: :validate_param_interactor do
  subject { described_class.call(recipient:) }

  context 'when attribute is missing' do
    let(:recipient) { nil }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(InvalidRecipientError)) }
  end

  context 'when attribute is present' do
    context 'when it is a valid siret' do
      let(:recipient) { valid_siret }

      it { is_expected.to be_a_success }

      its(:errors) { is_expected.to be_empty }
    end

    context 'when it is an invalid siret' do
      let(:recipient) { invalid_siret }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(InvalidRecipientError)) }
    end
  end
end
