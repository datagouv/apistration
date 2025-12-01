RSpec.describe GIPMDS::EffectifsAnnuelsEntreprise::BuildResource, type: :build_resource do
  let(:siren) { valid_siren }
  let(:year) { '2020' }
  let(:organizer) { described_class.call(response:, params:) }

  let(:response) { instance_double(Net::HTTPOK, body:) }
  let(:body) do
    gip_mds_stubbed_payload_for_annuel(
      siren:,
      year:,
      regime_agricole_effectifs: nil,
      regime_general_effectifs: '16.64'
    ).to_json
  end
  let(:params) do
    {
      siren:,
      year:
    }
  end

  describe 'resource' do
    subject { organizer.bundled_data.data }

    it { is_expected.to be_a(Resource) }

    it 'builds valid payload' do
      expect(subject.to_h).to eq(
        {
          siren:,
          effectifs_annuel: [
            {
              regime: 'regime_agricole',
              year:,
              nature: 'effectif_moyen_annuel',
              month: '12',
              value: nil,
              date_derniere_mise_a_jour: nil
            },
            {
              regime: 'regime_general',
              year:,
              nature: 'effectif_moyen_annuel',
              month: '12',
              value: 16.64,
              date_derniere_mise_a_jour: Time.zone.today
            }
          ]
        }
      )
    end

    context 'with nature_effectif parameter' do
      let(:params) do
        {
          siren:,
          year:,
          nature_effectif: 'boeth'
        }
      end

      let(:body) do
        gip_mds_stubbed_payload_for_annuel(
          siren:,
          year:,
          nature: 'A02',
          regime_agricole_effectifs: nil,
          regime_general_effectifs: '16.64'
        ).to_json
      end

      it 'builds payload with correct nature' do
        expect(subject.to_h).to eq(
          {
            siren:,
            effectifs_annuel: [
              {
                regime: 'regime_agricole',
                year:,
                nature: 'effectif_boeth_annuel',
                month: '12',
                value: nil,
                date_derniere_mise_a_jour: nil
              },
              {
                regime: 'regime_general',
                year:,
                nature: 'effectif_boeth_annuel',
                month: '12',
                value: 16.64,
                date_derniere_mise_a_jour: Time.zone.today
              }
            ]
          }
        )
      end
    end
  end
end
