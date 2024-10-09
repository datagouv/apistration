RSpec.describe APIParticulier::CNAV::AllocationAdulteHandicape::V2, type: :serializer do
  subject(:serialized_resource) { described_class.new(bundled_data.data, { scope: current_user, scope_name: :current_user }).serializable_hash }

  let(:bundled_data) { CNAV::AllocationAdulteHandicape::BuildResource.call(response:).bundled_data }
  # rubocop:disable Style/OpenStructUse
  let(:response) { OpenStruct.new(body:) }
  # rubocop:enable Style/OpenStructUse
  let(:body) { read_payload_file('cnav/allocation_adulte_handicape/make_request_valid.json') }

  let(:current_user) { JwtUser.new(uid: SecureRandom.uuid, scopes:, jti: SecureRandom.uuid, iat: 1.year.ago.to_i, exp: 1.year.from_now.to_i) }

  context 'with partial revenu solidarite active scopes' do
    context 'with allocation_adulte_handicape scope' do
      let(:scopes) { %w[allocation_adulte_handicape] }

      it 'has status, date_debut items' do
        expect(subject).to have_key(:status)
        expect(subject).to have_key(:dateDebut)
      end
    end
  end
end
