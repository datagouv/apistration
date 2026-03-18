RSpec.describe API::V2::CertificatsOPQIBIController, type: :controller do
  it_behaves_like 'unauthorized'
  it_behaves_like 'unprocessable_entity'
  it_behaves_like 'forbidden'
  it_behaves_like 'ask_for_mandatory_parameters'

  context 'when siren is not found by OPQIBI', vcr: { cassette_name: 'opqibi_with_not_found_siren' } do
    it_behaves_like 'not_found', siren: not_found_siren(:opqibi)
  end

  describe 'happy path' do
    let(:token) { yes_jwt }

    before do
      remember_through_each_test_of_current_scope('opqibi_valid_siren') do
        get :show, params: { siren: siren, token: token }.merge(mandatory_params)
        json = JSON.parse(response.body)
      end
    end

    subject { @opqibi_valid_siren }

    context 'when siren is known by OPQIBI', vcr: { cassette_name: 'opqibi_with_valid_siren' } do
      let(:siren) { valid_siren(:opqibi) }

      it 'returns 200'do
        expect(response).to have_http_status(200)
      end

      its(['siren'])                                           { is_expected.to eq(valid_siren(:opqibi)) }
      its(['numero_certificat'])                               { is_expected.to eq('85 04 0695') }
      its(['date_de_validite_des_qualifications_probatoires']) { is_expected.to eq('01/04/2021') }
      its(['duree_de_validite_du_certificat'])                 { is_expected.to eq('valable un an') }
      its(['assurance'])                                       { is_expected.to eq('ALLIANZ - AXA') }
      its(['url'])                                             { is_expected.to eq('http://opqibi.com/fiche.php?id=719') }

      context '#qualifications (non probatoire)' do
        let(:definition_qualification) { "Mission d'assistance technique en phase de conception ou réalisation d'une opération dans les domaines de la construction (bâtiment ou infrastructure), de l'environnement, de l'énergie ou des process industriels.<br /><br />Elle comprend au minimum :<br />- l'analyse des spécificités techniques d'une opération et des documents élaborés par le Maître d'ouvrage (programme,...) et/ou les autres intervenants (Maîtres d'œuvre, Entreprises,....)<br />- les conseils et propositions au Maître d'ouvrage qui en résultent <br /><br />Nota : comme toutes les missions d'AMO, cette mission ne correspond pas à une mission de maîtrise d'œuvre et ne peut donc être justifiée par des références de maîtrise d'œuvre.<br />" }

        its(['qualifications'])                      { is_expected.to be_a(Array) }
        its(['date_de_validite_des_qualifications']) { is_expected.to eq('01/04/2022') }

        it 'should have first qualification like' do
          expect(subject['qualifications'].first['code_qualification']).to eq('0103')
          expect(subject['qualifications'].first['nom']).to                eq('AMO en technique')
          expect(subject['qualifications'].first['definition']).to         eq(definition_qualification)
          expect(subject['qualifications'].first['rge']).to                eq('0')
        end
      end

      context '#qualifications probatoires' do
        let(:definition_qualification_probatoire) { "Réseaux de distribution d'eau potable ou industrielle de zones à aménager de faible importance, se raccordant à des installations existantes, avec ou sans renforcement." }

        its(['qualifications_probatoires'])                      { is_expected.to be_a(Array) }
        its(['date_de_validite_des_qualifications_probatoires']) { is_expected.to eq('01/04/2021') }

        it 'should have first qualification probatoire like' do
          expect(subject['qualifications_probatoires'].first['code_qualification']).to eq('1301')
          expect(subject['qualifications_probatoires'].first['nom']).to                eq('Étude de réseaux courants de distribution d\'eau')
          expect(subject['qualifications_probatoires'].first['definition']).to         eq(definition_qualification_probatoire)
          expect(subject['qualifications_probatoires'].first['rge']).to                eq('0')
        end
      end
    end
  end
end
