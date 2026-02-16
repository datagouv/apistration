RSpec.describe INPI::RNE::ActesBilans::BuildResource, type: :build_resource do
  let(:response) { instance_double(Net::HTTPOK, body:) }

  let(:url_regexp) { %r{^http://test\.entreprise\.api\.gouv\.fr/proxy/inpi/download/\S*$} }

  let(:params) do
    {
      siren: valid_siren(:inpi),
      token_id: 'token-id'
    }
  end

  before(:all) do
    Timecop.freeze
  end

  after(:all) do
    Timecop.return
  end

  describe 'resource' do
    describe 'with valid payload' do
      subject { described_class.call(response:, params:).bundled_data.data.to_h }

      let(:body) { read_payload_file('inpi/rne/actes_bilans/valid.json') }

      it do
        expect(subject).to include(
          {
            actes: [
              {
                id: '63e7e2e3998acaecf81b485e',
                nom_document: '000000000000_C0022A1001L167004D20240604H170356TPIJTES00111111',
                date_depot: '2024-01-29',
                date_mise_a_jour: '2024-06-07',
                types_actes: [
                  {
                    type_acte: 'Statuts mis à jour'
                  },
                  {
                    type_acte: "Décision(s) de l'associé unique",
                    type_decision: 'Modification(s) statutaire(s)'
                  }
                ],
                url: a_string_matching(url_regexp)
              },
              {
                id: '777d907f011c33736a087261',
                nom_document: 'cccccccccccc_C0022A1001L148042D20230325H170912TPIJTES00HHHHH',
                date_depot: '2023-03-20',
                date_mise_a_jour: '2023-10-26',
                types_actes: [
                  {
                    type_acte: "Décision(s) de l'associé unique",
                    type_decision: 'Renouvellement(s) de mandat(s) de commissaire(s) aux comptes'
                  }
                ],
                url: a_string_matching(url_regexp)
              }
            ],
            bilans: [
              { id: '999999d56fcc04967005a999',
                nom_document: 'CA_123456789_7501_K00059794156_2023_D',
                date_depot: '2024-03-01',
                date_cloture: '2023-08-31',
                date_mise_a_jour: '2024-04-12',
                type: 'bilan complet',
                url: a_string_matching(url_regexp) }
            ]
          }
        )
      end

      describe 'url uuid' do
        let(:url) { described_class.call(response:, params:).bundled_data.data.actes.first[:url] }
        let(:uuid) { url.split('/').last }
        let!(:decrypted_params) { JSON.parse(StringEncryptorService.instance.decrypt_url_safe(uuid)) }

        it 'has the right params' do
          expect(decrypted_params['target']).to eq('actes')
          expect(decrypted_params['document_id']).to eq('63e7e2e3998acaecf81b485e')
          expect(decrypted_params['timestamp']).to eq(Time.zone.now.to_i)
          expect(decrypted_params['token_id']).to eq('token-id')
        end
      end

      describe 'with some deleted actes' do
        let(:body) { read_payload_file('inpi/rne/actes_bilans/actes_deleted.json') }

        it 'doesnt show deleted actes' do
          expect(subject[:actes]).to be_empty
        end
      end
    end

    context 'with payload which has no bilans' do
      subject { described_class.call(response:, params:).bundled_data.data.to_h }

      let(:body) { read_payload_file('inpi/rne/actes_bilans/without_bilans.json') }

      it do
        expect(subject).to include(
          {
            actes: [
              {
                id: '63e7e2e3998acaecf81b485e',
                nom_document: '000000000000_C0022A1001L167004D20240604H170356TPIJTES00111111',
                date_depot: '2024-01-29',
                date_mise_a_jour: '2024-06-07',
                types_actes: [
                  {
                    type_acte: 'Statuts mis à jour'
                  },
                  {
                    type_acte: "Décision(s) de l'associé unique",
                    type_decision: 'Modification(s) statutaire(s)'
                  }
                ],
                url: a_string_matching(url_regexp)
              },
              {
                id: '777d907f011c33736a087261',
                nom_document: 'cccccccccccc_C0022A1001L148042D20230325H170912TPIJTES00HHHHH',
                date_depot: '2023-03-20',
                date_mise_a_jour: '2023-10-26',
                types_actes: [
                  {
                    type_acte: "Décision(s) de l'associé unique",
                    type_decision: 'Renouvellement(s) de mandat(s) de commissaire(s) aux comptes'
                  }
                ],
                url: a_string_matching(url_regexp)
              }
            ]
          }
        )
      end
    end
  end
end
