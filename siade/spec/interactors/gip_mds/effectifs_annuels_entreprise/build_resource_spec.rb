RSpec.describe GIPMDS::EffectifsAnnuelsEntreprise::BuildResource, type: :build_resource do
  let(:siren) { valid_siren }
  let(:year) { '2020' }
  let(:organizer) { described_class.call(response:) }

  let(:response) { instance_double(Net::HTTPOK, body:) }
  let(:body) do
    gip_mds_stubbed_payload_for_annuel(
      siren:,
      year:,
      regime_agricole_effectifs: nil,
      regime_general_effectifs: '16.64'
    ).to_json
  end

  describe 'resource' do
    subject { organizer.bundled_data.data }

    it { is_expected.to be_a(Resource) }

    it 'builds valid payload' do
      expect(subject.to_h).to eq(
        {
          siren:,
          annee: year,
          effectifs_annuel: {
            regime_general: {
              value: 16.64,
              date_derniere_mise_a_jour: Time.zone.today
            },
            regime_agricole: {
              value: nil,
              date_derniere_mise_a_jour: nil
            }
          }
        }
      )
    end
  end
end
