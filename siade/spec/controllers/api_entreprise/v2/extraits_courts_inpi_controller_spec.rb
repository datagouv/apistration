RSpec.describe APIEntreprise::V2::ExtraitsCourtsINPIController, type: :controller do
  it_behaves_like 'unauthorized'
  it_behaves_like 'forbidden'
  it_behaves_like 'unprocessable_entity'
  it_behaves_like 'ask_for_mandatory_parameters'

  # We are doing a search, we may return no results at all. 404 and no results are no good here. Maybe we should
  # make a check on existing siren
  # it_behaves_like 'not_found'

  describe 'happy path' do
    before do
      get :show, params: { siren: siren, token: token }.merge(mandatory_params)
    end

    let(:response_body) do
      json = JSON.parse(response.body)
    end

    context 'when user authenticates with valid token' do
      let(:token) { yes_jwt }

      context 'when siret is found', vcr: { cassette_name: 'extrait_court_inpi_peugeot' } do
        let(:siren) { valid_siren(:peugeot) }

        context 'global response' do
          subject { response_body }

          it 'returns 200' do
            expect(response.code).to eq '200'
          end

          context 'brevets' do
            subject { super()['brevets'] }

            its(['count']) { is_expected.to eq(13_161) }

            it 'latests_brevets' do
              latests_brevets = subject['latests_brevets']

              expect(latests_brevets).to be_a_kind_of(Array)
              expect(latests_brevets.size).to eq(5)
            end

            context 'latests_brevets sample' do
              subject { super()['latests_brevets'][0] }

              its(['date_publication'])    { is_expected.to eq('20170616') }
              its(['date_depot'])          { is_expected.to eq('20151214') }
              its(['numero_publication'])  { is_expected.to eq('<country>FR</country><doc-number>3045218</doc-number><kind>A1</kind>') }
              its(['titre'])               { is_expected.to eq('DETERMINATION DE PARAMETRES D&apos;UN MODELE DYNAMIQUE POUR UNE CELLULE ELECTROCHIMIQUE DE BATTERIE') }
            end
          end

          context 'modeles' do
            subject { super()['modeles'] }

            its(['count']) { is_expected.to eq(361) }

            it 'latests_modeles' do
              latests_modeles = subject['latests_modeles']

              expect(latests_modeles).to be_a_kind_of(Array)
              expect(latests_modeles.size).to eq(5)
            end

            context 'latests_modeles sample' do
              subject { super()['latests_modeles'][0] }

              its(['date_publication'])    { is_expected.to eq('20170602') }
              its(['date_depot'])          { is_expected.to eq('20140527') }
              its(['numero_identification']) { is_expected.to eq('20142275') }
              its(['titre']) { is_expected.to eq('Véhicule automobile, vues de détails') }
            end
          end

          context 'marques' do
            subject { super()['marques'] }

            its(['count']) { is_expected.to eq(16) }

            it 'latests_marques' do
              latests_marques = subject['latests_marques']

              expect(latests_marques).to be_a_kind_of(Array)
              expect(latests_marques.size).to eq(5)
            end

            context 'latests_marques sample' do
              subject { super()['latests_marques'][0] }

              its(['numero_identification']) { is_expected.to eq('4313413') }
              its(['marque'])                { is_expected.to be nil }
              its(['marque_status'])         { is_expected.to eq('Marque enregistrée') }
              its(['depositaire'])           { is_expected.to eq('PEUGEOT CITROËN AUTOMOBILES SA, Société anonyme') }
              its(['cle'])                   { is_expected.to eq('FMARK|4313413') }
            end
          end
        end
      end
    end
  end
end
