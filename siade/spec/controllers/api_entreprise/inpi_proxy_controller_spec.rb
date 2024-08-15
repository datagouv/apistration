RSpec.describe APIEntreprise::INPIProxyController do
  describe '#show', vcr: { cassette_name: 'inpi/rne/actes_download/valid' } do
    subject { response }

    let(:uuid) { StringEncryptorService.instance.encrypt_url_safe(raw_params) }
    let(:raw_params) { "#{target}-#{document_id}-#{timestamp}-#{token_id}" }
    let(:timestamp) { Time.zone.now.to_i }
    let(:target) { 'actes' }
    let(:document_id) { valid_rne_document_id }
    let(:token_id) { 'token_id' }

    let(:document_url_regexp) { %r{http://test\.entreprise\.api\.gouv\.fr/proxy/files/[a-f0-9\-]{36}} }

    before do
      get :show, params: { uuid: }
    end

    it { is_expected.to have_http_status(:ok) }

    it 'returns the document_url' do
      expect(subject.parsed_body[:data][:document_url]).to match(document_url_regexp)
    end

    describe 'with a wrong uuid' do
      let(:uuid) { 'invalid_stuff' }

      it { is_expected.to have_http_status(:unprocessable_entity) }

      its(:parsed_body) { is_expected.to include({ error: 'UUID Invalide' }) }
    end

    describe 'with an expired link' do
      let(:timestamp) { 2.hours.ago.to_i }

      it { is_expected.to have_http_status(:gone) }
      its(:parsed_body) { is_expected.to include({ error: 'Le lien a expiré. La durée de validité est de 1 heure.' }) }
    end
  end
end
