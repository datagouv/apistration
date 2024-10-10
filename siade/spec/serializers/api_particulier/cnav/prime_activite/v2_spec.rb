RSpec.describe APIParticulier::CNAV::PrimeActivite::V2, type: :serializer do
  subject(:serialized_resource) { described_class.new(bundled_data.data, { scope: current_user, scope_name: :current_user }).serializable_hash }

  let(:bundled_data) { CNAV::PrimeActivite::BuildResource.call(response:).bundled_data }
  let(:response) { OpenStruct.new(body:) }
  let(:body) { read_payload_file('cnav/prime_activite/make_request_valid.json') }

  let(:current_user) { JwtUser.new(uid: SecureRandom.uuid, scopes:, jti: SecureRandom.uuid, iat: 1.year.ago.to_i, exp: 1.year.from_now.to_i) }

  context 'with partial prime activite scopes' do
    context 'with prime_activite scope' do
      let(:scopes) { %w[prime_activite prime_activite_majoration] }

      it 'has status, date_debut items' do
        expect(subject).to have_key(:status)
        expect(subject).to have_key(:majoration)
        expect(subject).to have_key(:dateDebut)
        expect(subject).to have_key(:dateFin)
      end
    end
  end
end
