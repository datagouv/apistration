RSpec.describe Qualifelec::Certificats::Authenticate, type: :interactor do
  subject { described_class.call }

  before do
    stub_qualifelec_auth_success
  end

  context 'when qualifelec authentication succeeds' do
    it { is_expected.to be_a_success }

    it 'fills context with token' do
      expect(subject.token).to be_present
    end
  end
end
