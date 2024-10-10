RSpec.describe APIParticulier::CNAV::ComplementaireSanteSolidaire::V2, type: :serializer do
  subject(:serialized_resource) { described_class.new(bundled_data.data, { scope: current_user, scope_name: :current_user }).serializable_hash }

  let(:bundled_data) { CNAV::ComplementaireSanteSolidaire::BuildResource.call(response:).bundled_data }
  let(:response) { OpenStruct.new(body:) }
  let(:body) { read_payload_file('cnav/complementaire_sante_solidaire/make_request_valid.json') }

  let(:current_user) { JwtUser.new(uid: SecureRandom.uuid, scopes:, jti: SecureRandom.uuid, iat: 1.year.ago.to_i, exp: 1.year.from_now.to_i) }

  context 'with partial complementaire sante solidaire scopes' do
    context 'with complementaire_sante_solidaire scope' do
      let(:scopes) { %w[complementaire_sante_solidaire] }

      it 'has status, date_debut items' do
        expect(subject).to have_key(:status)
        expect(subject).to have_key(:dateDebut)
        expect(subject).to have_key(:dateFin)
      end
    end
  end
end
