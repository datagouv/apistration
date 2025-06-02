RSpec.describe DataSubvention::Subventions::Authenticate, type: :interactor do
  subject { described_class.call }

  before do
    stub_datasubvention_subventions_authenticate
  end

  context 'when on happy path' do
    it { is_expected.to be_a_success }

    it 'fills context with token' do
      expect(subject.token).to be_present
    end
  end
end
