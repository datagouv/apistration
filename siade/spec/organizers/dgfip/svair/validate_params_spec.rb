RSpec.describe DGFIP::SVAIR::ValidateParams, type: :validate_params do
  subject { described_class.call(params:) }

  let(:params) do
    {
      tax_number:,
      tax_notice_number:
    }
  end

  let(:tax_number) { valid_tax_number }
  let(:tax_notice_number) { valid_tax_notice_number }

  context 'with valid params' do
    it { is_expected.to be_a_success }

    its(:errors) { is_expected.to be_empty }
  end

  context 'with invalid tax number' do
    let(:tax_number) { 'invalid' }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
  end

  context 'with invalid tax notice number' do
    let(:tax_notice_number) { 'invalid' }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
  end
end
