RSpec.describe ACOSSError, type: :error do
  it_behaves_like 'a valid error' do
    let(:instance) { described_class.new(:ongoing_manual_verification) }
  end

  describe '#meta' do
    subject { described_class.new(:ongoing_manual_verification).meta }

    it 'has a retry_in key, which specifies in seconds when approximatively the document will be available' do
      expect(subject[:retry_in]).to eq(2.days.to_i)
    end
  end
end
