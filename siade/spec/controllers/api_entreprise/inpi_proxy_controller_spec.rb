RSpec.describe APIEntreprise::INPIProxyController do
  describe '#show' do
    subject do
      get :show, params: { uuid: }
    end

    let(:uuid) { StringEncryptorService.instance.encrypt_url_safe(raw_params) }
    let(:raw_params) do
      {
        target:,
        document_id:,
        timestamp:,
        token_id:
      }.to_json
    end
    let(:timestamp) { Time.zone.now.to_i }
    let(:target) { 'actes' }
    let(:document_id) { valid_rne_document_id }
    let(:token_id) { 'c1a72399-2fdd-427e-a9f7-dc480f158603' }

    let(:document_url_regexp) { %r{http://test\.entreprise\.api\.gouv\.fr/proxy/files/[a-f0-9-]{36}} }

    before(:all) do
      Token.create!(
        id: 'c1a72399-2fdd-427e-a9f7-dc480f158603',
        iat: 2.hours.ago.to_i,
        exp: 3.hours.from_now.to_i,
        authorization_request_model_id: AuthorizationRequest.create.id,
        scopes: %w[open_data]
      )
    end

    describe 'error format (with wrong uuid)' do
      let(:uuid) { 'invalid_stuff' }

      its(:parsed_body) { is_expected.to have_json_api_format_errors }
    end

    describe 'when RNE renders valid response', vcr: { cassette_name: 'inpi/rne/actes_download/valid' } do
      it { is_expected.to have_http_status(:ok) }

      it 'returns the document_url' do
        expect(subject.parsed_body[:data][:document_url]).to match(document_url_regexp)
      end

      describe 'with a wrong uuid' do
        let(:uuid) { 'invalid_stuff' }

        it { is_expected.to have_http_status(:unprocessable_content) }
        its(:parsed_body) { is_expected.to have_json_error(detail: "Le paramètre uuid n'est pas correctement formatté") }
      end

      describe 'with an expired link' do
        let(:timestamp) { 2.hours.ago.to_i }

        it { is_expected.to have_http_status(:gone) }
        its(:parsed_body) { is_expected.to have_json_error(detail: 'Le lien de téléchargement est expiré.') }
      end

      describe 'when it is a bilan', vcr: { cassette_name: 'inpi/rne/bilans_download/valid' } do
        let(:target) { 'bilans' }

        it { is_expected.to have_http_status(:ok) }

        it 'returns the document_url' do
          expect(subject.parsed_body[:data][:document_url]).to match(document_url_regexp)
        end
      end
    end

    describe 'when rne renders a 404', vcr: { cassette_name: 'inpi/rne/authenticate' } do
      before do
        stub_inpi_rne_download_not_found(target:, document_id:)
      end

      it { is_expected.to have_http_status(:not_found) }
    end
  end
end
