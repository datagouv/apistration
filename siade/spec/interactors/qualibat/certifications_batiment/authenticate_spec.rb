RSpec.describe QUALIBAT::CertificationsBatiment::Authenticate, type: :interactor do
  subject { described_class.call }

  context 'when authentication succeed' do
    before { stub_qualibat_authenticate }

    it { is_expected.to be_a_success }

    it 'fills context with token' do
      expect(subject.token).to be_present
    end
  end
end
