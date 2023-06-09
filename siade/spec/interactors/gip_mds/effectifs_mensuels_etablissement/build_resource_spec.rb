RSpec.describe GIPMDS::EffectifsMensuelsEtablissement::BuildResource, type: :build_resource do
  let(:siret) { valid_siret }
  let(:year) { '2020' }
  let(:month) { '01' }
  let(:organizer) { described_class.call(response:, params:) }

  let(:response) { instance_double(Net::HTTPOK, body:) }
  let(:body) do
    gip_mds_stubbed_payload_for_mensuel(
      siret:,
      year:,
      month:,
      regime_agricole_effectifs: nil,
      regime_general_effectifs: '16.64'
    ).to_json
  end
  let(:params) do
    {
      siret:,
      year:,
      month:
    }
  end

  describe 'resource' do
    subject { organizer.bundled_data.data }

    it { is_expected.to be_a(Resource) }

    it 'builds valid payload' do
      expect(subject.to_h).to eq(
        {
          siret:,
          depth: '0',
          effectifs_mensuels: [
            {
              regime: 'regime_agricole',
              year:,
              month: '01',
              value: nil,
              date_derniere_mise_a_jour: nil
            },
            {
              regime: 'regime_general',
              year:,
              month: '01',
              value: 16.64,
              date_derniere_mise_a_jour: Time.zone.today
            }
          ]
        }
      )
    end
  end
end
