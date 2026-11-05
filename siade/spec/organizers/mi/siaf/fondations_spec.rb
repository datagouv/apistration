RSpec.describe MI::SIAF::Fondations, type: :retriever_organizer do
  subject { described_class.call(params:, operation_id: 'api_entreprise_v3_mi_siaf_fondations', recipient: '13002526500013') }

  let(:params) do
    {
      siren_or_siret_or_rnf: valid_rnf_id
    }
  end

  describe 'with a known fondation' do
    let(:fondation) { subject.bundled_data.data }

    before do
      stub_siaf_fondation
    end

    it { is_expected.to be_a_success }

    it 'never serves documents nor accounts' do
      expect(fondation.to_h.keys).to eq(%i[identifiants identite activites filiation dirigeants beneficiaires_effectifs situation_financiere])
    end

    it 'serves only the directors still in office, with name, first name, function and quality' do
      expect(fondation.dirigeants).to eq(
        [
          { nom: 'DUPONT', prenom: 'Marie', fonction: 'Président', qualite: "Membre du conseil d'administration" }
        ]
      )
    end

    it 'serves the full identity of every beneficial owner, including those who left office, without the legal entity they represent' do
      expect(fondation.beneficiaires_effectifs).to contain_exactly(
        include(nom: 'DUPONT', date_sortie_fonction: nil),
        {
          nom: 'MARTIN',
          prenom: 'Paul',
          fonction: nil,
          qualite: 'Personne exerçant des fonctions de direction',
          date_naissance: Date.new(1960, 1, 30),
          nationalite: 'Belgique',
          pays_residence: 'Suisse',
          profession: 'Banquier',
          date_entree_fonction: Date.new(2010, 3, 1),
          date_sortie_fonction: Date.new(2021, 12, 31),
          fondateur: true,
          adresse_domiciliation: { adresse_complete: '3 Chemin Exemple 1200 Genève', pays: 'Suisse' }
        }
      )
    end

    it 'serves the public subsidies, public generosity and foreign financing years' do
      expect(fondation.situation_financiere).to eq(
        annees_subventions_publiques: [2024, 2025],
        annees_appel_generosite_publique: [2024],
        annees_financements_etrangers: [2023]
      )
    end

    it 'deduces the siren from the siret' do
      expect(fondation.identifiants).to eq(rnf: '075-FRUP-00194-01', siren: '784308934', siret_siege: '78430893400016')
    end

    it 'keeps a general interest domain whose label contains a comma whole' do
      expect(fondation.activites[:domaines_interet_general]).to eq(
        [
          'Scientifique',
          'Diffusion de la culture, de la langue et des connaissances scientifiques françaises',
          'Éducatif'
        ]
      )
    end

    it 'names the instructing department' do
      expect(fondation.identite[:service_instructeur]).to eq(code: '75', libelle: 'Paris')
    end

    it 'gives the fiscal year end as month and day' do
      expect(fondation.identite[:cloture_exercice]).to eq(mois: 6, jour: 30)
    end

    it 'derives an indefinite duration from the absence of term date' do
      expect(fondation.identite).to include(duree_determinee: false, date_terme: nil)
    end

    it 'serves the head office address on a single clean line' do
      expect(fondation.identite[:adresse_siege]).to eq(
        adresse_complete: '28 Rue Saint-Dominique 75007 Paris',
        numero_voie: '28',
        libelle_voie: 'Rue Saint-Dominique',
        code_insee: '75107',
        code_postal: '75007',
        commune: 'Paris 7e Arrondissement',
        pays: 'France'
      )
    end

    it 'lists the organisms the fondation comes from' do
      expect(fondation.filiation).to eq([{ type_operation: 'Transformation', identifiant: 'W751028723' }])
    end
  end

  describe 'with a fondation without siret, created for a fixed term' do
    let(:fondation) { subject.bundled_data.data }

    before do
      payload = JSON.parse(read_payload_file('mi/siaf/fondations/valid.json'))
      payload.merge!('siret' => nil, 'dueDate' => '2029-05-14T00:00:00.000Z', 'fromLineage' => nil)

      stub_siaf_fondation(body: payload.to_json)
    end

    it 'serves null identifiers from Sirene' do
      expect(fondation.identifiants).to include(siren: nil, siret_siege: nil)
    end

    it 'serves the term date' do
      expect(fondation.identite).to include(duree_determinee: true, date_terme: Date.new(2029, 5, 14))
    end

    it 'serves an empty filiation' do
      expect(fondation.filiation).to eq([])
    end
  end

  describe 'with directors whose term starts or ends in the future' do
    let(:fondation) { subject.bundled_data.data }

    before do
      payload = JSON.parse(read_payload_file('mi/siaf/fondations/valid.json'))
      payload['persons'][0]['exitAt'] = 1.year.from_now.iso8601
      payload['persons'][1].merge!('entryAt' => 1.month.from_now.iso8601, 'exitAt' => nil)

      stub_siaf_fondation(body: payload.to_json)
    end

    it 'keeps a director until the departure date and leaves out one not yet in office' do
      expect(fondation.dirigeants.pluck(:nom)).to eq(%w[DUPONT])
    end
  end

  [true, nil].each do |is_person_data_private|
    describe "with a fondation whose persons confidentiality flag is #{is_person_data_private.inspect}" do
      let(:fondation) { subject.bundled_data.data }

      before do
        payload = JSON.parse(read_payload_file('mi/siaf/fondations/valid.json'))
        payload['isPersonDataPrivate'] = is_person_data_private

        stub_siaf_fondation(body: payload.to_json)
      end

      it 'serves no person at all' do
        expect(fondation.dirigeants).to eq([])
        expect(fondation.beneficiaires_effectifs).to eq([])
      end
    end
  end

  describe 'with a general interest domain unknown to the nomenclature' do
    let(:fondation) { subject.bundled_data.data }

    before do
      payload = JSON.parse(read_payload_file('mi/siaf/fondations/valid.json'))
      payload['generalInterestDomain'] = 'Culturel et sportif, Social'

      stub_siaf_fondation(body: payload.to_json)
    end

    it 'keeps it whole even when it starts with a known label' do
      expect(fondation.activites[:domaines_interet_general]).to eq(['Culturel et sportif', 'Social'])
    end
  end

  describe 'with an unknown fondation' do
    let(:params) do
      {
        siren_or_siret_or_rnf: non_existing_rnf_id
      }
    end

    before do
      stub_siaf_fondation_not_found
    end

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(NotFoundError)) }
  end

  describe 'invalid params' do
    let(:params) do
      {
        siren_or_siret_or_rnf: invalid_rnf_id
      }
    end

    it { is_expected.to be_a_failure }
  end
end
