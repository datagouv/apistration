RSpec.describe APIParticulier::CNOUS::EtudiantBoursier::V4, type: :serializer do
  subject { described_class.new(bundled_data, current_user).serializable_hash }

  let(:bundled_data) { CNOUS::BuildResource.call(response:).bundled_data }

  let(:response) { OpenStruct.new(body:) }

  let(:current_user) { JwtUser.new(uid: SecureRandom.uuid, scopes:, jti: SecureRandom.uuid, iat: 1.year.ago.to_i, exp: 1.year.from_now.to_i) }

  let(:all_cnous_scopes) { %w[cnous_identite cnous_email cnous_statut_boursier cnous_echelon_bourse cnous_periode_versement cnous_ville_etudes] }

  context 'with non-removed student' do
    let(:body) { cnous_valid_payload('ine').to_json }

    context 'with cnous_statut_boursier scope' do
      let(:scopes) { %w[cnous_statut_boursier] }

      it 'nests est_boursier and radiation fields under statut_boursier' do
        expect(subject[:data]).to have_key(:statut_boursier)
        expect(subject[:data]).not_to have_key(:est_boursier)

        statut = subject[:data][:statut_boursier]
        expect(statut[:est_boursier]).to be true
        expect(statut[:est_radie]).to be false
        expect(statut[:date_radiation]).to be_nil
      end
    end

    context 'without cnous_statut_boursier scope' do
      let(:scopes) { %w[cnous_identite] }

      it 'does not have statut_boursier' do
        expect(subject[:data]).not_to have_key(:statut_boursier)
        expect(subject[:data]).not_to have_key(:est_boursier)
      end
    end
  end

  context 'with removed student' do
    let(:body) { read_payload_file('cnous/student_scholarship_valid_response_removed.json') }

    context 'with cnous_statut_boursier scope' do
      let(:scopes) { %w[cnous_statut_boursier] }

      it 'returns correct values for removed student' do
        statut = subject[:data][:statut_boursier]
        expect(statut[:est_radie]).to be true
        expect(statut[:date_radiation]).to eq('2023-06-15')
      end
    end
  end
end
