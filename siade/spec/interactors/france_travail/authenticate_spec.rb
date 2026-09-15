RSpec.describe FranceTravail::Authenticate, type: :interactor do
  subject { described_class.call }

  context 'when France Travail authentication succeed' do
    before { stub_france_travail_authenticate }

    it { is_expected.to be_a_success }

    it 'fills context with token' do
      expect(subject.token).to be_present
    end
  end
end
