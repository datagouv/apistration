RSpec.describe DGFIP::LiassesFiscales::EnrichResource, type: :interactor do
  subject(:enricher) { described_class.call(bundled_data:, params:) }

  let(:bundled_data) { builder.bundled_data }
  let(:builder) { DGFIP::LiassesFiscales::BuildResource.call(response:) }
  let(:response) { instance_double(Net::HTTPOK, body:) }
  let(:body) { extract_dgfip_liasses_fiscales_payload('obligation_fiscale_simplified').to_json }

  let(:params) do
    {
      siren: valid_siren(:liasse_fiscale),
      user_id: valid_dgfip_user_id,
      year: 2017
    }
  end

  let(:dictionary_key_1) { 'dgfip:dictionnaires:year_2017:imprime_2033A' }
  let(:dictionary_key_2) { 'dgfip:dictionnaires:year_2017:imprime_2033B' }
  let(:dictionary_data_1) do
    [
      {
        'code' => 'Z0',
        'code_EDI' => 'XX:X123:2222:2:XX0',
        'code_absolu' => '2345670',
        'code_nref' => '304330',
        'code_type_donnee' => 'XX0',
        'intitule' => 'Déposé néant0'
      }
    ]
  end
  let(:dictionary_data_2) do
    [
      {
        'code' => 'Z1',
        'code_EDI' => 'XX:X123:2222:2:XX1',
        'code_absolu' => '2345671',
        'code_nref' => '304331',
        'code_type_donnee' => 'XX1',
        'intitule' => 'Déposé néant1'
      }
    ]
  end

  let(:enriched_payload) do
    [
      {
        date_declaration: '2017-07-10',
        date_fin_exercice: '2017-03-31',
        donnees:
          [
            {
              code: 'Z0',
              code_EDI: 'XX:X123:2222:2:XX0',
              code_absolu: '2345670',
              code_nref: '304330',
              code_type_donnee: 'XX0',
              intitule: 'Déposé néant0',
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
        regime:
          {
            code: 'RS',
            libelle: 'Régime simplifié'
          }
      },
      {
        date_declaration: '2017-07-10',
        date_fin_exercice: '2017-03-31',
        donnees:
          [
            {
              code: 'Z1',
              code_EDI: 'XX:X123:2222:2:XX1',
              code_absolu: '2345671',
              code_nref: '304331',
              code_type_donnee: 'XX1',
              intitule: 'Déposé néant1',
              valeurs: ['3333']
            }
          ],
        duree_exercice: 365,
        millesime: '201701',
        numero_imprime: '2033B',
        regime:
          {
            code: 'RS',
            libelle: 'Régime simplifié'
          }
      }
    ]
  end

  before do
    allow(DGFIP::Dictionaries).to receive(:call).with(key: dictionary_key_1).and_return(dictionary_data_1)
    allow(DGFIP::Dictionaries).to receive(:call).with(key: dictionary_key_2).and_return(dictionary_data_2)
  end

  it 'enrich the payload with dictionary data' do
    expect(enricher.bundled_data.data.declarations).to eq(enriched_payload)
  end
end
