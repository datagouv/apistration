RSpec.describe APIParticulier::ANTS::ExtraitImmatriculationVehiculeSerializer::V3, type: :serializer do
  subject { described_class.new(bundled_data, current_user).serializable_hash }

  let(:bundled_data) { ANTS::ExtraitImmatriculationVehicule::BuildResource.call(response:, holder:, matchings:, matches: true).bundled_data }
  let(:response) { instance_double(Net::HTTPOK, body:) }
  let(:body) { read_payload_file('ants/found.json') }
  let(:holder) { JSON.parse(body)['listeDossiers'][0]['personne']['qualiteType'][0] }
  let(:matchings) { { 'familyname' => true, 'givenname' => true, 'birthdate' => birthdate_matches } }

  let(:current_user) { JwtUser.new(uid: SecureRandom.uuid, scopes: [], jti: SecureRandom.uuid, iat: 1.year.ago.to_i, exp: 1.year.from_now.to_i) }

  describe 'identity matching meta' do
    subject { super()[:meta][:identity_matching] }

    context 'when the birth date matches' do
      let(:birthdate_matches) { true }

      it { is_expected.to eq(family_name: 1.0, given_name: 1.0, birth_date: 1.0, overall_match: true) }
    end

    context 'when the birth date does not match' do
      let(:birthdate_matches) { false }

      it { is_expected.to eq(family_name: 1.0, given_name: 1.0, birth_date: 0.0, overall_match: true) }
    end
  end
end
