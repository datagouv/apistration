RSpec.describe DGFIP::Authenticate, type: :organizer do
  subject { described_class.call }

  context 'when it works', vcr: { cassette_name: 'dgfip/authenticate/valid' } do
    it { is_expected.to be_a_success }

    its(:cookie) { is_expected.to be_present }
  end

  context 'when it does not work', vcr: { cassette_name: 'dgfip/authenticate/wrong_secret' } do
    before do
      stub_credential(:dgfip_secret, 'wrong_secret')
    end

    it { is_expected.to be_a_failure }

    its(:cookie) { is_expected.to be_blank }
    its(:errors) { is_expected.to include(ProviderAuthenticationError) }
  end
end
