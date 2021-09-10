RSpec.describe SIADE::V2::Retrievers::AttestationsFiscalesDGFIP do
  let(:user_id) { valid_dgfip_user_id }
  let(:cookie)  { 'valid_cookie' }

  describe 'Driver correctly delegate methods' do
    subject { described_class.new(siren: valid_siren(:dgfip), user_id: user_id, cookie: cookie) }

    let(:driver) { SIADE::V2::Drivers::AttestationsFiscalesDGFIP }

    it { is_expected.to be_delegated_to(driver, :http_code) }
    it { is_expected.to be_delegated_to(driver, :document_url) }
  end

  describe 'should retrieve dgfip informations', vcr: { cassette_name: 'attestations_fiscales_dgfip_retriever' } do
    subject do
      described_class.new(
        siren: valid_siren(:dgfip),
        siren_is: danone_siren,
        siren_tva: danone_siren,
        user_id: user_id,
        cookie: cookie
      )
    end

    it 'returns a correct hash' do
      adapter = subject.send(:retrieve_dgfip_informations)
      expect(adapter).to be_valid
    end
  end

  context 'INSEE fallback usage' do
    subject do
      described_class.new(
        siren: valid_siren(:dgfip),
        siren_is: danone_siren,
        siren_tva: danone_siren,
        user_id: user_id,
        cookie: cookie
      )
    end

    context 'when INSEE is UP', vcr: { cassette_name: 'attestations_fiscales_dgfip_retriever' } do
      it 'returns a correct hash' do
        adapter = subject.send(:retrieve_dgfip_informations)
        expect(adapter).to be_valid
      end

      it 'logs once http code' do
        expect(ProviderResponseSpy).to receive(:log_http_code).exactly(5).times
        subject.retrieve
      end
    end
  end
end
