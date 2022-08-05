RSpec.describe PoleEmploi::Authenticate, type: :interactor do
  subject { described_class.call }

  context 'when pole emploi authentication succeed', vcr: { cassette_name: 'pole_emploi/oauth2' } do
    it { is_expected.to be_a_success }

    it 'fills context with token' do
      expect(subject.token).to be_present
    end
  end
end
