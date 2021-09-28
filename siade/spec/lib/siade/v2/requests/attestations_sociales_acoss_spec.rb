RSpec.describe SIADE::V2::Requests::AttestationsSocialesACOSS, type: :provider_request do
  subject do
    described_class.new(
      {
        siren: siren,
        type_attestation: type_attestation,
        user_id: user_id,
        recipient: recipient
      }
    ).perform
  end

  let(:valid_type_attestation) { 'AVG_UR' }
  let(:user_id) { 'user id' }
  let(:recipient) { 'SIRET of someone' }

  describe 'request failed' do
    context 'when the siren is invalid' do
      let(:siren) { invalid_siren }
      let(:type_attestation) { valid_type_attestation }

      its(:http_code) { is_expected.to eq(422) }
      its(:errors)    { is_expected.to have_error(invalid_siren_error_message) }
    end

    context 'when type attestation is invalid' do
      let(:siren) { valid_siren }
      let(:type_attestation) { 'INVALID' }

      its(:http_code) { is_expected.to eq(422) }
      its(:errors) { is_expected.to have_error("Le type d'attestation indiqué n\'est pas correctement formatté (uniquement: AVG_UR)") }
    end

    context 'when non-existent siren', vcr: { cassette_name: 'acoss/with_non_existent_siren' } do
      let(:siren) { non_existent_siren }
      let(:type_attestation) { valid_type_attestation }

      its(:http_code) { is_expected.to eq(404) }
      its(:errors) { is_expected.to have_error("Siren invalide, l'ACOSS ne peut délivrer d'attestation (erreur: Le siren est inconnu du SI Attestations, radié ou hors périmètre Code d'erreur ACOSS : FUNC517)") }
    end

    context 'when siren raise a timeout' do
      before do
        allow_any_instance_of(SIADE::V2::OAuth2::ACOSSTokenProvider).to receive(:token).and_return('dummy token')
        allow_any_instance_of(SIADE::V2::Requests::Generic).to receive(:net_http_post_call).and_raise(Net::ReadTimeout)
      end

      let(:siren) { '662042449' } # BNP Paribas
      let(:type_attestation) { valid_type_attestation }

      it 'has a timeout response' do
        expect(subject.response.class).to eq(SIADE::V2::Responses::TimeoutError)
      end
    end
  end

  context 'when token retrieval fails' do
    let(:siren) { valid_siren(:acoss) }
    let(:type_attestation) { valid_type_attestation }

    before do
      allow_any_instance_of(SIADE::V2::OAuth2::ACOSSTokenProvider)
        .to receive(:token)
        .and_raise(SIADE::V2::OAuth2::AbstractTokenProvider::Error, 'dummy error')
    end

    its(:http_code) { is_expected.to eq(502) }
    its(:errors) { is_expected.to have_error("L'ACOSS ne peut répondre à votre requête, réessayez ultérieurement (erreur: dummy error)") }
  end

  describe 'happy path', vcr: { cassette_name: 'acoss/with_valid_siren' } do
    context 'when siren and type attestation are valid' do
      let(:siren) { valid_siren(:acoss) }
      let(:type_attestation) { valid_type_attestation }

      its(:http_code) { is_expected.to eq(200) }
      its(:errors) { is_expected.to be_empty }

      it 'contains the user_id and recipient in the payload' do
        payload = JSON.parse(subject.send(:post_request_body))
        expect(payload).to include_json(
          idClient: user_id,
          beneficiaire: recipient
        )
      end
    end

    context 'when type attestation, user_id and recipient are nil' do
      subject { described_class.new({ siren: valid_siren(:acoss) }).perform }

      its(:http_code) { is_expected.to eq(200) }
      its(:errors) { is_expected.to be_empty }

      it 'contains the default user_id and recipient in the payload' do
        payload = JSON.parse(subject.send(:post_request_body))
        expect(payload).to include_json(
          idClient: '1',
          beneficiaire: '1'
        )
      end
    end
  end
end
