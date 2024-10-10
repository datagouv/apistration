RSpec.describe APIParticulier::MEN::Scolarites::V2, type: :serializer do
  subject(:serialized_resource) { described_class.new(resource, { scope: current_user, scope_name: :current_user }).serializable_hash }

  let(:current_user) { JwtUser.new(uid: SecureRandom.uuid, scopes:, jti: SecureRandom.uuid, iat: 1.year.ago.to_i, exp: 1.year.from_now.to_i) }

  let(:resource) { MEN::Scolarites::BuildResource.call(response:).bundled_data.data }
  let(:response) { OpenStruct.new(body:) }
  let(:body) { open_payload_file('men/scolarites/valid.json').read }

  let(:all_men_scopes) { %w[men_statut_scolarite men_statut_boursier men_echelon_bourse] }

  context 'with all men scopes' do
    let(:scopes) { all_men_scopes }

    it 'has all keys' do
      expect(serialized_resource).to have_key(:est_scolarise)
      expect(serialized_resource).to have_key(:est_boursier)
      expect(serialized_resource).to have_key(:niveau_bourse)
    end
  end

  context 'without men_echelon_bourse scope' do
    let(:scopes) { %w[men_statut_scolarite men_echelon_bourse] }

    it 'has key est_scolarise' do
      expect(serialized_resource).to have_key(:est_scolarise)
    end

    it 'doesnt have key est_boursier' do
      expect(serialized_resource).not_to have_key(:est_boursier)
    end
  end

  context 'without men_statut_boursier scope' do
    let(:scopes) { %w[men_statut_scolarite men_echelon_bourse] }

    it 'has key est_scolarise' do
      expect(serialized_resource).to have_key(:est_scolarise)
    end

    it 'doesnt have key est_boursier' do
      expect(serialized_resource).not_to have_key(:est_boursier)
    end

    it 'doesnt have key niveau_bourse' do
      expect(serialized_resource).not_to have_key(:niveau_boursee)
    end
  end

  context 'without men_statut_scolarite scope' do
    let(:scopes) { %w[men_statut_boursier] }

    it 'doesnt have key est_scolarise' do
      expect(serialized_resource).not_to have_key(:est_scolarise)
    end

    it 'has key est_boursier' do
      expect(serialized_resource).to have_key(:est_boursier)
    end
  end
end
