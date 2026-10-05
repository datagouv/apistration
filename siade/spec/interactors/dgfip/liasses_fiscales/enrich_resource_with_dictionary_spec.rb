RSpec.describe DGFIP::LiassesFiscales::EnrichResourceWithDictionary, type: :interactor do
  subject(:enricher) { described_class.call(bundled_data:, dictionaries:, default_dictionary_key: '2017') }

  let(:bundled_data) { builder.bundled_data }
  let(:builder) { DGFIP::LiassesFiscales::BuildResourceWithoutDictionary.call(response:) }
  let(:response) { instance_double(Net::HTTPOK, body:) }
  let(:body) { extract_dgfip_liasses_fiscales_payload('obligation_fiscale_simplified').to_json }

  let(:dictionaries) { { '2017' => JSON.parse(open_payload_file('dgfip/dictionary.json').read)['dictionnaire'] } }

  let(:enriched_payload) do
    [
      {
        date_declaration: '2017-07-10',
        date_fin_exercice: '2017-03-31',
        donnees: [
          {
            code: 'XX',
            code_EDI: 'XX:X123:4567:0:XXX',
            code_absolu: '1234567',
            code_nref: '123456',
            code_type_donnee: 'XXX',
            intitule: 'Intitulé 1',
            valeurs: ['1111']
          },
          {
            code_nref: '304331',
            valeurs: ['2222']
          }
        ],
        duree_exercice: 365,
        millesime: '201701',
        numero_imprime: '2033A',
        regime: {
          code: 'RS',
          libelle: 'Régime simplifié'
        }
      },
      {
        date_declaration: '2017-07-10',
        date_fin_exercice: '2017-03-31',
        donnees: [
          {
            code_nref: '304331',
            valeurs: ['3333']
          },
          {
            code_nref: '304814',
            valeurs: [
              'JEAN DUPONT',
              'JACQUES DUPOND'
            ]
          }
        ],
        duree_exercice: 365,
        millesime: '201701',
        numero_imprime: '2033B',
        regime: {
          code: 'RS',
          libelle: 'Régime simplifié'
        }
      }
    ]
  end

  it 'enrich the payload with dictionary data' do
    expect(enricher.bundled_data.data.declarations).to eq(enriched_payload)
  end

  describe 'dictionary selection' do
    subject(:donnees) do
      described_class.call(declarations:, dictionaries:, default_dictionary_key:).declarations.first[:donnees]
    end

    let(:default_dictionary_key) { '2025' }

    let(:dictionaries) { { '2025' => local_dictionary(2025), '2026' => local_dictionary(2026) } }
    let(:donnees_f1_g1) { [{ code_nref: '914984', valeurs: ['1000'] }, { code_nref: '914985', valeurs: ['500'] }] }

    def local_dictionary(year)
      JSON.parse(Rails.root.join("config/dgfip/dictionnaires/#{year}.json").read)['dictionnaire']
    end

    context 'when the declaration has a millesime' do
      let(:declarations) { [{ numero_imprime: '2052', millesime: '202601', donnees: donnees_f1_g1 }] }

      it 'enriches with the dictionary of the millesime year' do
        expect(donnees.pluck(:code, :intitule)).to eq([
          ['GX', 'Produits de cessions d’immobilisation incorporelles et corporelles'],
          ['GY', 'Valeurs comptables des immobilisations incorporelles et corporelles cédées']
        ])
      end
    end

    context 'when the declaration has no millesime' do
      let(:declarations) { [{ numero_imprime: '2052', millesime: nil, donnees: donnees_f1_g1 }] }
      let(:default_dictionary_key) { '2026' }

      it 'enriches with the default dictionary' do
        expect(donnees.pluck(:code)).to eq(%w[GX GY])
      end
    end
  end
end
