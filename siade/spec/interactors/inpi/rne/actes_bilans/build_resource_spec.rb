RSpec.describe INPI::RNE::ActesBilans::BuildResource, type: :build_resource do
  let(:response) { instance_double(Net::HTTPOK, body:) }

  let(:body) { read_payload_file('inpi/rne/actes_bilans/valid.json') }

  let(:params) do
    {
      siren: valid_siren(:inpi)
    }
  end

  describe 'resource' do
    subject { described_class.call(response:).bundled_data.data.to_h }

    it do
      expect(subject).to eq(
        {
          actes: [
            {
              updated_at: '2024-06-07',
              date_depot: '2024-01-29',
              nom_document: '000000000000_C0022A1001L167004D20240604H170356TPIJTES00111111',
              id: '777276ab77779828c40677eb',
              types: [
                {
                  acte: 'Statuts mis à jour'
                },
                {
                  acte: "Décision(s) de l'associé unique",
                  decision: 'Modification(s) statutaire(s)'
                }
              ]
            },
            {
              updated_at: '2023-10-26',
              date_depot: '2023-03-20',
              nom_document: 'cccccccccccc_C0022A1001L148042D20230325H170912TPIJTES00HHHHH',
              id: '777d907f011c33736a087261',
              types: [
                {
                  acte: "Décision(s) de l'associé unique",
                  decision: 'Renouvellement(s) de mandat(s) de commissaire(s) aux comptes'
                }
              ]
            }
          ],
          bilans: [
            updated_at: '2024-04-12',
            date_depot: '2024-03-01',
            nom_document: 'CA_123456789_7501_K00059794156_2023_D',
            id: '999999d56fcc04967005a999',
            date_cloture: '2023-08-31',
            type: 'C'
          ]
        }
      )
    end

    describe 'with some deleted actes' do
      let(:body) { read_payload_file('inpi/rne/actes_bilans/actes_deleted.json') }

      it 'doesnt show deleted actes' do
        expect(subject[:actes]).to be_empty
      end
    end
  end
end
