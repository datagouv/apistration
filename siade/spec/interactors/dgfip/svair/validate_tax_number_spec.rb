RSpec.describe DGFIP::SVAIR::ValidateTaxNumber, type: :validate_param do
  subject { described_class.call(params: { tax_number: }) }

  context 'when it is 13 alpha numeric string' do
    let(:tax_number) { '0123456789ABC' }

    it { is_expected.to be_a_success }

    its(:errors) { is_expected.to be_empty }
  end

  context 'when it is 13 non alpha numeric string' do
    let(:tax_number) { '0123456789AB]' }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
  end

  context 'when it is 12 alpha numeric string' do
    let(:tax_number) { '0123456789AB' }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
  end

  context 'when it is 14 alpha numeric string' do
    let(:tax_number) { '0123456789ABCD' }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
  end
end
