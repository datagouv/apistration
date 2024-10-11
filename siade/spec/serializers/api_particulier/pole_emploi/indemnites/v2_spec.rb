RSpec.describe APIParticulier::PoleEmploi::Indemnites::V2, type: :serializer do
  subject(:serialized_resource) { described_class.new(bundled_data.data, { scope: current_user, scope_name: :current_user }).serializable_hash }

  let(:bundled_data) { FranceTravail::Indemnites::BuildResource.call(params: { identifiant: 'test' }, response:).bundled_data }
  # rubocop:disable Style/OpenStructUse
  let(:response) { OpenStruct.new(body:) }
  # rubocop:enable Style/OpenStructUse
  let(:body) { read_payload_file('france_travail/indemnites/valid.json') }

  let(:current_user) { JwtUser.new(uid: SecureRandom.uuid, scopes:, jti: SecureRandom.uuid, iat: 1.year.ago.to_i, exp: 1.year.from_now.to_i) }

  context 'with all france travail indemnite scopes' do
    let(:scopes) { %w[pole_emploi_paiements] }

    it 'has status, date_debut items' do
      expect(subject).to have_key(:identifiant)
      expect(subject).to have_key(:paiements)
    end
  end

  context 'with partial france travail indemnite scopes' do
    let(:scopes) { [] }

    it 'has identifiant idem' do
      expect(subject).to have_key(:identifiant)
      expect(subject).not_to have_key(:paiements)
    end
  end
end
