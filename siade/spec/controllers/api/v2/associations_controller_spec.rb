RSpec.describe API::V2::AssociationsController, type: :controller do
  it_behaves_like 'unauthorized', :show, id: valid_rna_id
  it_behaves_like 'forbidden', :show, id: valid_rna_id
  it_behaves_like 'unprocessable_entity', :show, :siret_or_rna, id: invalid_siret
  it_behaves_like 'ask_for_mandatory_parameters', :show, id: valid_rna_id

  describe 'invalid rna association' do
    let(:id) { '11111111111111' }
    let(:token) { yes_jwt }

    subject do
      get :show, params: { id: id, token: token }.merge(mandatory_params)
    end

    its(:status) { is_expected.to eq(422) }

    it 'returns 422 with error message' do
      json = JSON::parse(subject.body)

      expect(json).to have_json_error(
        detail: 'Le numéro de siret ou le numéro d\'association indiqué n\'est pas correctement formatté',
      )
    end
  end

  describe 'happy path' do
    subject { get :show, params: { id: id, token: token }.merge(mandatory_params) }

    context 'when using a RNA' do
      context 'when RNA id exists', vcr: { cassette_name: 'rna_association/W952002436' } do

        let(:id)    { 'W952002436' }
        let(:token) { yes_jwt }
        let(:json)  { JSON.parse(subject.body, symbolize_names: true) }

        it 'returns 200' do
          expect(subject.status).to eq(200)
        end

        it 'contains field association' do
          expect(json).to have_key(:association)
        end

        context 'field association' do
          before do
            remember_through_each_test_of_current_scope('associations_controller_json_association') do
              get :show, params: { id: id, token: yes_jwt }.merge(mandatory_params)
              json = JSON.parse(response.body, symbolize_names: true)[:association]
            end
          end

          subject { @associations_controller_json_association }

          its([:id])                      { is_expected.to eq(id) }
          its([:titre])                   { is_expected.to eq('GROSLAY SPORT PETANQUE') }
          its([:siret_siege_social])      { is_expected.to eq('52933947500012') }
          its([:objet])                   { is_expected.to eq("développer la pratique du sport pétanque et jeu provençal, faciliter la formation d'arbitres et d'éducateurs et favoriser la création d'une école de pétanque") }
          its([:date_creation])           { is_expected.to eq('2010-11-29') }
          its([:date_declaration])        { is_expected.to eq('2011-12-09') }
          its([:date_publication])        { is_expected.to eq('2010-12-11') }
          its([:date_dissolution])        { is_expected.to eq('2011-11-26') }
          its([:code_civilite_dirigeant]) { is_expected.to eq(nil) }
          its([:civilite_dirigeant])      { is_expected.to eq(nil) }
          its([:code_etat])               { is_expected.to eq(nil) }
          its([:etat])                    { is_expected.to eq("false") }
          its([:code_groupement])         { is_expected.to eq(nil) }
          its([:groupement])              { is_expected.to eq('Simple') }
          its([:mise_a_jour])             { is_expected.to eq("2011-12-09") }

          context 'adresse_siege' do
            subject { super()[:adresse_siege] }

            its([:complement])   { is_expected.to eq('  ') }
            its([:numero_voie])  { is_expected.to eq('29') }
            its([:type_voie])    { is_expected.to eq('AV') }
            its([:libelle_voie]) { is_expected.to eq('de la République') }
            its([:distribution]) { is_expected.to eq('_') }
            its([:code_insee])   { is_expected.to eq('95288') }
            its([:code_postal])  { is_expected.to eq('95410') }
            its([:commune])      { is_expected.to eq('Groslay') }
          end
        end
      end # end valid RNA id

      context 'when id does not exist', vcr: { cassette_name: 'rna_association/non_existing_rna_id' } do

        let(:id)    { non_existing_rna_id }
        let(:token) { yes_jwt }

        it 'returns 404' do
          expect(subject.status).to eq(404)
        end
      end

    end # end using RNA

    context 'when using a siret', vcr: { cassette_name: 'rna_association/42135938100025' } do
      context 'when siret is correct' do
        context 'when siret is found' do

          let(:id)    { '42135938100025' }
          let(:token) { yes_jwt }

          its(:status) { is_expected.to eq(200) }

          context 'association retrieved' do
            subject { JSON.parse(super().body) }

            it { expect(subject['association']['id']).to                 eq ("W751135389") }
            it { expect(subject['association']['siret_siege_social']).to eq ("42135938100033") }
            it { expect(subject['association']['siret']).to              eq ('42135938100025') }
          end
        end

        context 'when siret is not found', vcr: { cassette_name: 'rna_association/W000000000' } do

          let(:id)    { 'W000000000' }
          let(:token) { yes_jwt }

          it { expect(subject.status).to eq(404) }
        end
      end

      context 'when siret is not valid', vcr: { cassette_name: 'rna_association/11111111111111' } do

        let(:id)    { '11111111111111' }
        let(:token) { yes_jwt }

        it { expect(subject.status).to eq(422) }
      end
    end # end using siret
  end
end
