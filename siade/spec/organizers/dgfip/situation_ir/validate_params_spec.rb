RSpec.describe DGFIP::SituationIR::ValidateParams, type: :validate_params do
  subject { described_class.call(params:) }

  let(:params) do
    {
      tax_number:,
      tax_notice_number:
    }
  end

  context 'with valid params' do
    let(:tax_number) { valid_tax_number }
    let(:tax_notice_number) { valid_tax_notice_number }

    it { is_expected.to be_a_success }
  end

  context 'with empty tax notice number' do
    let(:tax_number) { valid_tax_number }
    let(:tax_notice_number) { nil }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to be_present }
  end
end
