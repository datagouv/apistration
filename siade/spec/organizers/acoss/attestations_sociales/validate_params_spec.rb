RSpec.describe ACOSS::AttestationsSociales::ValidateParams, type: :validate_params do
  subject { described_class.call(params:, recipient:) }

  let(:params) do
    {
      siren:,
      user_id:
    }
  end

  let(:siren) { valid_siren }
  let(:user_id) { '9001' }
  let(:recipient) { valid_siret }

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
