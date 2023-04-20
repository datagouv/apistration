RSpec.describe DGFIP::SituationIR::BuildResource, type: :build_resource do
  describe '.call', vcr: { cassette_name: 'dgfip/situation_ir/valid' } do
    subject(:call) { described_class.call(response:) }

    let(:response) { instance_double(Net::HTTPOK, body:) }

    let(:token) do
      DGFIP::SituationIR::Authenticate.call.token
    end

    let(:body) do
      DGFIP::SituationIR::MakeRequest.call(token:, params:).response.body
    end

    let(:params) { { tax_number:, tax_notice_number: } }
    let(:tax_number) { '1234567890ABC' }
    let(:tax_notice_number) { '2134567890ABC' }

    let(:valid_payload) do
      {
        declarant1: {
          nom: 'CIS CINQ',
          nomNaissance: 'CIS CINQ',
          prenoms: 'PRENOM TATIANA',
          dateNaissance: '30/09/1945'
        },
        declarant2: {
          nom: '',
          nomNaissance: 'CIS VINGTSEPT',
          prenoms: 'PRENOM GABIN',
          dateNaissance: '06/11/1973'
        },
        foyerFiscal: {
          adresse: '55 BOULEVARD MARCELLIN BERTHELOT 13200 ARLES',
          annee: 2022
        },
        dateRecouvrement: '31/07/2022',
        dateEtablissement: '07/07/2022',
        nombreParts: 6.75,
        situationFamille: 'Pacsé(e)s',
        revenuBrutGlobal: 13_070,
        revenuImposable: 10_586,
        impotRevenuNetAvantCorrections: 99,
        montantImpot: nil,
        revenuFiscalReference: 33_640,
        nombrePersonnesCharge: 5,
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
