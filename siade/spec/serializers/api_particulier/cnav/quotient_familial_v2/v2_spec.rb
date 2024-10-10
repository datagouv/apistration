RSpec.describe APIParticulier::CNAV::QuotientFamilialV2::V2, type: :serializer do
  subject(:serialized_resource) { described_class.new(resource, { scope: current_user, scope_name: :current_user }).serializable_hash }

  let(:current_user) { JwtUser.new(uid: SecureRandom.uuid, scopes:, jti: SecureRandom.uuid, iat: 1.year.ago.to_i, exp: 1.year.from_now.to_i) }
  let(:params) { { annee:, mois: } }
  let(:annee) { Time.zone.today.year }
  let(:mois) { Time.zone.today.month }

  let(:resource) { CNAV::QuotientFamilialV2::BuildResource.call(response:, params:).bundled_data.data }
  let(:response) { OpenStruct.new(body:) }
  let(:body) { read_payload_file('cnav/quotient_familial_v2/make_request_valid.json') }

  let(:all_scopes) { %w[cnaf_quotient_familial cnaf_allocataires cnaf_enfants cnaf_adresse openid identite_pivot] }

  before do
    response['X-APISECU-FD'] = CNAV::QuotientFamilialV2::REGIME_CODE_CNAF
  end

  context 'with all scopes' do
    let(:scopes) { all_scopes }

    it 'has enfants' do
      expect(serialized_resource).to have_key(:enfants)
    end
  end

  context 'with no enfants scope' do
    let(:scopes) { all_scopes - %w[cnaf_enfants] }

    it 'doesnt have enfants' do
      expect(serialized_resource).not_to have_key(:enfants)
    end
  end
end
