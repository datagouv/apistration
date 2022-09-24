RSpec.describe APIParticulier::CNOUS::StudentScholarship::V2, type: :serializer do
  subject(:serialized_resource) { described_class.new(resource, { scope: current_user, scope_name: :current_user }).serializable_hash }

  let(:current_user) { JwtUser.new(uid: SecureRandom.uuid, scopes:, jti: SecureRandom.uuid, iat: 1.year.ago.to_i, exp: 1.year.from_now.to_i) }

  let(:resource) { CNOUS::BuildResource.call(response:).bundled_data.data }
  let(:response) { OpenStruct.new(body:) } # rubocop:disable Style/OpenStructUse
  let(:body) { Rails.root.join('spec/fixtures/payloads/cnous/student_scholarship_valid_response.json').read }

  let(:all_scopes) { %w[cnous_identite cnous_email cnous_statut_boursier cnous_echelon_bourse cnous_statut_bourse cnous_periode_versement cnous_ville_etudes] }

  context 'with all scopes' do
    let(:scopes) { all_scopes }

    it 'has key email' do
      expect(serialized_resource).to have_key(:email)
    end
  end

  context 'with just email scope' do
    let(:scopes) { 'cnous_email' }

    it 'has key email' do
      expect(serialized_resource).to have_key(:email)
    end

    it 'doesnt have key lastName' do
      expect(serialized_resource).not_to have_key(:lastName)
    end
  end
end
