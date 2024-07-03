RSpec.describe INPI::RNE::ValidateDocumentId, type: :validate_params do
  subject { described_class.call(params: { document_id: }) }

  context 'with valid id' do
    let(:document_id) { valid_rne_document_id }

    it { is_expected.to be_a_success }

    its(:errors) { is_expected.to be_empty }
  end

  context 'with invalid id' do
    let(:document_id) { 'invalid' }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
  end

  context 'when user_id is empty' do
    let(:document_id) { nil }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
  end
end
