RSpec.describe CNAF::ComplementaireSanteSolidaire::Authenticate, type: :interactor do
  subject { described_class.call }

  before do
    stub_cnaf_complementaire_sante_solidaire_authenticate
  end

  context 'when complementaire sante solidaire authentication succeed' do
    it { is_expected.to be_a_success }

    it 'fills context with token' do
      expect(subject.token).to be_present
    end
  end
end
