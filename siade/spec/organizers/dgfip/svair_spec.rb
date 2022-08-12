RSpec.describe DGFIP::SVAIR, type: :retriever_organizer do
  subject { described_class.call(params:) }

  let(:params) do
    {
      tax_number:,
      tax_notice_number:
    }
  end

  let(:tax_number) { '1234567890ABC' }
  let(:tax_notice_number) { '1234567890ABC' }

  describe 'happy path' do
    before do
      mock_valid_dgfip_svair
    end

    it { is_expected.to be_a_success }

    it 'retrieves the resource' do
      resource = subject.bundled_data.data

      expect(resource).to be_present
    end
  end
end
