RSpec.describe IdentityMatcher do
  subject { described_class.call(candidate_identity: identite, reference_identity: identite_pivot) }

  let(:identite) do
    {
      nom_naissance: 'DUPONT',
      prenoms: ['JEAN'],
      sexe_etat_civil: 'M',
      annee_date_naissance: 1955,
      mois_date_naissance: 12,
      jour_date_naissance: 8,
      code_departement_naissance: '59'
    }
  end

  let(:identite_pivot) do
    {
      nom_naissance: 'DUPONT',
      prenoms: ['JEAN'],
      sexe_etat_civil: 'M',
      annee_date_naissance: 1955,
      mois_date_naissance: 12,
      jour_date_naissance: 8,
      code_cog_insee_commune_naissance: '59001'
    }
  end

  describe 'when all fields match' do
    it { is_expected.to be_a_success }

    it 'sets matches to true' do
      expect(subject.matches).to be true
    end
  end

  describe 'when name does not match' do
    let(:identite) do
      {
        nom_naissance: 'MARTIN',
        prenoms: ['JEAN'],
        sexe_etat_civil: 'M',
        annee_date_naissance: 1955,
        mois_date_naissance: 12,
        jour_date_naissance: 8,
        code_departement_naissance: '59'
      }
    end

    it { is_expected.to be_a_failure }

    it 'sets matches to false' do
      expect(subject.matches).to be false
    end
  end
end
