RSpec.describe APIParticulier::CNAV::AllocationSoutienFamilial::V2, type: :serializer do
  subject(:serialized_resource) { described_class.new(bundled_data.data, { scope: current_user, scope_name: :current_user }).serializable_hash }

  let(:bundled_data) { CNAV::AllocationSoutienFamilial::BuildResource.call(response:).bundled_data }
  # rubocop:disable Style/OpenStructUse
  let(:response) { OpenStruct.new(body:) }
  # rubocop:enable Style/OpenStructUse
  let(:body) { read_payload_file('cnav/allocation_soutien_familial/make_request_valid.json') }

  let(:current_user) { JwtUser.new(uid: SecureRandom.uuid, scopes:, jti: SecureRandom.uuid, iat: 1.year.ago.to_i, exp: 1.year.from_now.to_i) }

  context 'with partial allocation soutien familial scopes' do
    context 'with allocation_soutien_familial scope' do
      let(:scopes) { %w[allocation_soutien_familial] }

      it 'has status, date_debut items' do
        expect(subject).to have_key(:status)
        expect(subject).to have_key(:dateDebut)
        expect(subject).to have_key(:dateFin)
      end
    end
  end
end
