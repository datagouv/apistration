RSpec.describe CNAF::Authenticate, type: :interactor do
  subject { described_class.call(dss_prestation_name: 'complementaire_sante_solidaire') }

  let(:cache_key) { :'cnaf/authenticate_complementaire_sante_solidaire' }
  let(:token) { 'super_valid_token' }

  before do
    stub_cnaf_authenticate('complementaire_sante_solidaire')
  end

  context 'when complementaire sante solidaire authentication succeed' do
    it { is_expected.to be_a_success }

    it 'fills context with token' do
      expect(subject.token).to be_present
    end

    it 'caches the token with a customized key' do
      expect(EncryptedCache.instance).to receive(:write).with(cache_key, token, expires_in: anything)

      subject
    end
  end
end
