RSpec.describe CNAF::QuotientFamilial::ValidateParams, type: :validate_params do
  subject { described_class.call(params:) }

  let(:params) do
    {
      postal_code:,
      beneficiary_number:
    }
  end

  let(:postal_code) { '75001' }
  let(:beneficiary_number) { '1234567' }

  context 'with valid attributes' do
    it { is_expected.to be_a_success }
  end

  context 'with invalid postal code' do
    let(:postal_code) { 'nope' }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
  end

  context 'with invalid beneficiary number' do
    let(:beneficiary_number) { 'nope' }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
  end
end
