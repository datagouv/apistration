RSpec.describe CNAF::QuotientFamilial, type: :retriever_organizer do
  describe '.call' do
    subject { described_class.call(params:) }

    let(:params) do
      {
        postal_code:,
        beneficiary_number:
      }
    end

    let(:postal_code) { '75001' }
    let(:beneficiary_number) { '1234567' }

    describe 'happy path' do
      before do
        mock_valid_cnaf_quotient_familial
      end

      it { is_expected.to be_a_success }

      it 'retrieves the resource' do
        resource = subject.bundled_data.data

        expect(resource).to be_present
      end
    end
  end
end
