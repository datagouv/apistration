RSpec.describe APIParticulier::CNOUS::EtudiantBoursier::V3, type: :serializer do
  subject { described_class.new(bundled_data, current_user).serializable_hash }

  let(:bundled_data) { CNOUS::BuildResource.call(response:).bundled_data }
  # rubocop:disable Style/OpenStructUse
  let(:response) { OpenStruct.new(body:) }
  # rubocop:enable Style/OpenStructUse
  let(:body) { cnous_valid_payload('ine').to_json }

  let(:current_user) { JwtUser.new(uid: SecureRandom.uuid, scopes:, jti: SecureRandom.uuid, iat: 1.year.ago.to_i, exp: 1.year.from_now.to_i) }

  let(:all_cnous_scopes) { %w[cnous_identite cnous_email cnous_statut_boursier cnous_echelon_bourse cnous_statut_bourse cnous_periode_versement cnous_ville_etudes] }

  context 'with all cnous scopes' do
    let(:scopes) { all_cnous_scopes }

    it 'has key email' do
      expect(subject[:data]).to have_key(:email)
    end
  end

  context 'with just email scope' do
    let(:scopes) { 'cnous_email' }

    it 'has key email' do
      expect(subject[:data]).to have_key(:email)
    end

    it 'doesnt have key last_name' do
      expect(subject[:data]).not_to have_key(:last_name)
    end
  end
end
