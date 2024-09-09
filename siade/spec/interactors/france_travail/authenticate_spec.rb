RSpec.describe FranceTravail::Authenticate, type: :interactor do
  subject { described_class.call }

  context 'when France Travail authentication succeed', vcr: { cassette_name: 'france_travail/oauth2' } do
    it { is_expected.to be_a_success }

    it 'fills context with token' do
      expect(subject.token).to be_present
    end
  end
end
