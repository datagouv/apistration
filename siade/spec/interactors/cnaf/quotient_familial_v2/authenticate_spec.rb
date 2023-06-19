RSpec.describe CNAF::QuotientFamilialV2::Authenticate, type: :interactor do
  subject { described_class.call }

  before do
    stub_cnaf_quotient_familial_v2_authenticate
  end

  context 'when quotient familial v2 authentication succeed' do
    it { is_expected.to be_a_success }

    it 'fills context with token' do
      expect(subject.token).to be_present
    end
  end
end
