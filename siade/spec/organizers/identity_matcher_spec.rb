RSpec.describe IdentityMatcher do
  subject { described_class.call(candidate_identity:, reference_identity:) }

  let(:candidate_identity) do
    {
      nom_naissance: 'DUPONT',
      prenoms: ['JEAN'],
      annee_date_naissance: 1955,
      mois_date_naissance: 12,
      jour_date_naissance: 8
    }
  end

  let(:reference_identity) do
    {
      nom_naissance: 'DUPONT',
      prenoms: ['JEAN'],
      annee_date_naissance: 1955,
      mois_date_naissance: 12,
      jour_date_naissance: 8
    }
  end

  describe 'when all fields match' do
    it { is_expected.to be_a_success }

    it 'sets matches to true' do
      expect(subject.matches).to be true
    end
  end

  describe 'when one of the given_names match any in reference_identity' do
    let(:reference_identity) do
      {
        nom_naissance: 'DUPONT',
        prenoms: ['JACQUES-JEAN-PASCAL'],
        annee_date_naissance: 1955,
        mois_date_naissance: 12,
        jour_date_naissance: 8
      }
    end

    it { is_expected.to be_a_success }

    it 'sets matches to true' do
      expect(subject.matches).to be true
    end
  end

  describe 'when name does not match' do
    let(:candidate_identity) do
      {
        nom_naissance: 'MARTIN',
        prenoms: ['JEAN'],
        annee_date_naissance: 1955,
        mois_date_naissance: 12,
        jour_date_naissance: 8
      }
    end

    it { is_expected.to be_a_failure }

    it 'sets matches to false' do
      expect(subject.matches).to be false
    end
  end
end
