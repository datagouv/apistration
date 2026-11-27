RSpec.describe APIParticulier::GIPMDS::ServiceCiviqueSerializer::V3, type: :serializer do
  subject { described_class.new(bundled_data, current_user).serializable_hash[:data] }

  let(:bundled_data) { GIPMDS::ServiceCivique::BuildResource.call(response:).bundled_data }
  let(:response) { instance_double(Net::HTTPOK, body: read_payload_file('gip_mds/service_civique/valid.json')) }
  let(:current_user) { JwtUser.new(uid: SecureRandom.uuid, scopes:, jti: SecureRandom.uuid, iat: 1.year.ago.to_i, exp: 1.year.from_now.to_i) }

  context 'with the organisme_accueil scope only' do
    let(:scopes) { %w[gip_mds_service_civique_organisme_accueil] }

    it 'returns the host organisation, without the dates' do
      expect(subject).to eq(organisme_accueil: { siret: '34442248200013' })
    end
  end

  context 'with the dates scope only' do
    let(:scopes) { %w[gip_mds_service_civique_dates] }

    it 'returns the dates, without the host organisation' do
      expect(subject).to eq(dates: { debut: '2025-12-01', fin: nil, en_cours: true })
    end
  end
end
