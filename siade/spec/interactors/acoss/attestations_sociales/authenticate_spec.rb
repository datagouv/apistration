RSpec.describe ACOSS::AttestationsSociales::Authenticate, type: :interactor do
  subject { described_class.call }

  context 'when acoss authentication succeed' do
    before { mock_urssaf_authenticate }

    it { is_expected.to be_a_success }

    it 'fills context with token' do
      expect(subject.token).to eq('access_token')
    end
  end
end
