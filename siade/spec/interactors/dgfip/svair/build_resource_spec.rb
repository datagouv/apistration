RSpec.describe DGFIP::SVAIR::BuildResource, type: :build_resource do
  subject { instance }

  let(:instance) { described_class.call(response:) }

  let(:response) do
    instance_double(Net::HTTPOK, body:)
  end

  describe 'resource' do
    subject { instance.bundled_data.data.to_h }

    context 'with one declarant, with impots, 3 lines for address' do
      let(:body) { read_payload_file('dgfip/svair/valid_response_one_declarant.html') }

      it do
        expect(subject).to eq(
          {
            declarant1: {
              nom: 'DUPONT',
              nomNaissance: 'DUPONT',
              prenoms: 'JEAN',
              dateNaissance: '01/01/2000'
            },
            declarant2: {
              nom: '',
              nomNaissance: '',
              prenoms: '',
              dateNaissance: ''
            },
            foyerFiscal: {
              adresse: 'APPARTEMENT 42 42 RUE DE LA PAIX 75001 PARIS',
              annee: 2021
            },
            dateRecouvrement: '31/07/2021',
            dateEtablissement: '08/07/2021',
            nombreParts: 1.0,
            situationFamille: 'Célibataire',
            revenuBrutGlobal: 2002,
            revenuImposable: 2001,
            impotRevenuNetAvantCorrections: 2,
            montantImpot: 1,
            revenuFiscalReference: 2000,
            nombrePersonnesCharge: 0,
            anneeImpots: '2021',
            anneeRevenus: '2020',
            erreurCorrectif: '',
            situationPartielle: ''
          }
        )
      end
    end

    context 'with two declarants, without impots, 2 lines for address' do
      let(:body) { read_payload_file('dgfip/svair/valid_response_two_declarants.html') }

      it do
        expect(subject).to eq(
          {
            declarant1: {
              nom: 'DUPONT',
              nomNaissance: 'DUPONT',
              prenoms: 'JEAN',
              dateNaissance: '01/01/2000'
            },
            declarant2: {
              nom: 'DUPONT',
              nomNaissance: 'MARTIN',
              prenoms: 'JEANNE',
              dateNaissance: '01/02/2000'
            },
            foyerFiscal: {
              adresse: '42 RUE DE LA PAIX 75001 PARIS',
              annee: 2021
            },
            dateRecouvrement: '31/07/2021',
            dateEtablissement: '08/07/2021',
            nombreParts: 2.0,
            situationFamille: 'Pacsé(e)s',
            revenuBrutGlobal: 5002,
            revenuImposable: 5001,
            impotRevenuNetAvantCorrections: nil,
            montantImpot: nil,
            revenuFiscalReference: 5000,
            nombrePersonnesCharge: 0,
            anneeImpots: '2021',
            anneeRevenus: '2020',
            erreurCorrectif: '',
            situationPartielle: ''
          }
        )
      end
    end
  end
end
