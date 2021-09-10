RSpec.describe ACOSS::AttestationsSociales::ValidateParams, type: :validate_params do
  subject { described_class.call(params: params) }

  let(:params) do
    {
      siren: siren,
      user_id: user_id,
      recipient: recipient
    }
  end

  let(:siren) { valid_siren }
  let(:user_id) { '9001' }
  let(:recipient) { 'DINUM' }

  context 'with valid params' do
    it { is_expected.to be_a_success }
  end

  context 'with invalid siren' do
    let(:siren) { invalid_siren }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to be_present }
  end

  context 'with invalid user_id' do
    let(:user_id) { nil }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to be_present }
  end

  context 'with invalid recipient' do
    let(:recipient) { nil }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to be_present }
  end
end
