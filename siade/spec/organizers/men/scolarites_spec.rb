RSpec.describe MEN::Scolarites, type: :retriever_organizer do
  describe '.call' do
    subject { described_class.call(params:) }

    before do
      stub_men_scolarites_auth
    end

    context 'with code_etablissement mode' do
      let(:params) do
        {
          nom_naissance: 'NOMFAMILLE',
          prenoms: ['prenom'],
          sexe_etat_civil: 'f',
          annee_date_naissance: '2000',
          mois_date_naissance: '06',
          jour_date_naissance: '10',
          code_etablissement: '0511474A',
          annee_scolaire: '2021',
          degre_etablissement: nil,
          codes_bcn_departements: nil,
          codes_bcn_regions: nil,
          provider_api_version: 'v1'
        }
      end

      before { stub_men_scolarites_valid }

      it { is_expected.to be_a_success }

      it 'retrieves the resource' do
        resource = subject.bundled_data.data

        expect(resource).to be_present
      end
    end

    context 'with perimetre mode' do
      let(:params) do
        {
          nom_naissance: 'NOMFAMILLE',
          prenoms: ['prenom'],
          sexe_etat_civil: 'f',
          annee_date_naissance: '2000',
          mois_date_naissance: '06',
          jour_date_naissance: '10',
          code_etablissement: nil,
          annee_scolaire: '2021',
          degre_etablissement: '2D',
          codes_bcn_departements: nil,
          codes_bcn_regions: %w[11],
          provider_api_version: 'v2'
        }
      end

      before { stub_men_scolarites_perimetre_valid }

      it { is_expected.to be_a_success }

      it 'retrieves the resource' do
        resource = subject.bundled_data.data

        expect(resource).to be_present
      end
    end
  end
end
