RSpec.describe DGFIP::SituationIR::BuildResource, type: :build_resource do
  describe '.call', vcr: { cassette_name: 'dgfip/situation_ir/valid' } do
    subject(:call) { described_class.call(response:, params: { tax_number:, tax_notice_number: }) }

    let(:response) { instance_double(Net::HTTPOK, body:) }

    let(:token) do
      DGFIP::SituationIR::Authenticate.call.token
    end

    let(:body) do
      DGFIP::SituationIR::MakeRequest.call(token:, params:).response.body
    end

    let(:params) { { tax_number:, tax_notice_number: } }
    let(:tax_number) { valid_tax_number }
    let(:tax_notice_number) { valid_tax_notice_number }

    let(:valid_payload) do
      {
        declarant1: {
          nom: '',
          nomNaissance: 'CIS QUATORZE',
          prenoms: 'PRENOM VINCENT',
          dateNaissance: '02/08/1973'
        },
        declarant2: {
          nom: 'CIS QUATORZE',
          nomNaissance: 'CIS TRENTEHUIT',
          prenoms: 'PNM LEA',
          dateNaissance: '10/02/1973'
        },
        foyerFiscal: {
          adresse: '18 RUE DU COMMANDANT MOWAT 94300 VINCENNES',
          annee: 2022
        },
        dateRecouvrement: '31/07/2022',
        dateEtablissement: '07/07/2022',
        nombreParts: 2.0,
        situationFamille: 'Marié(e)s',
        revenuBrutGlobal: 47_560,
        revenuImposable: 47_560,
        impotRevenuNetAvantCorrections: nil,
        montantImpot: 2982,
        revenuFiscalReference: 48_583,
        nombrePersonnesCharge: 0,
        anneeImpots: '2022',
        anneeRevenus: '2021',
        erreurCorrectif: '',
        situationPartielle: ''
      }
    end

    it { is_expected.to be_a_success }

    it 'builds a valid resource' do
      expect(call.bundled_data.data).to be_a(Resource)
    end

    it 'has a valid payload' do
      expect(call.bundled_data.data.to_h).to eq(valid_payload)
    end
  end
end
