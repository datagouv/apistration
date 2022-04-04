RSpec.describe DGFIP::AttestationFiscale::ValidateParams, type: :validate_params do
  subject { described_class.call(params:) }

  let(:params) do
    {
      siren:,
      user_id:
    }
  end

  let(:siren) { valid_siren }
  let(:user_id) { SecureRandom.uuid }

  context 'with valid attributes' do
    it { is_expected.to be_a_success }
  end

  context 'with invalid siren' do
    let(:siren) { '1234567890000' }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
  end

  context 'with invalid user_id' do
    let(:user_id) { '1234567890' }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
  end
end
