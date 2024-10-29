RSpec.describe DGFIP::ADELIE::Authenticate, type: :interactor do
  subject { described_class.call }

  context 'when authentication succeed', vcr: { cassette_name: 'dgfip/adelie/oauth2' } do
    let(:access_token_from_vcr_dgfip) { 'feedme' }

    it { is_expected.to be_a_success }

    it 'fills context with access token' do
      expect(subject.token).to start_with access_token_from_vcr_dgfip
    end
  end
end
