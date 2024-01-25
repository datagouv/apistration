RSpec.describe DGFIP::LiassesFiscales::EnrichResourceWithDictionary, type: :interactor do
  subject(:enricher) { described_class.call(bundled_data:, params:, dictionary:) }

  let(:bundled_data) { builder.bundled_data }
  let(:builder) { DGFIP::LiassesFiscales::BuildResourceWithoutDictionary.call(response:) }
  let(:response) { instance_double(Net::HTTPOK, body:) }
  let(:body) { extract_dgfip_liasses_fiscales_payload('obligation_fiscale_simplified').to_json }

  let(:params) do
    {
      siren: valid_siren(:liasse_fiscale),
      user_id: valid_dgfip_user_id,
      year:
    }
  end
  let(:year) { 2017 }

  let(:dictionary) { JSON.parse(open_payload_file('dgfip/dictionary.json').read)['dictionnaire'] }

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
end
