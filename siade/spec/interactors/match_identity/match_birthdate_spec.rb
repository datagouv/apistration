RSpec.describe MatchIdentity::MatchBirthdate do
  subject { described_class.call(candidate_identity: identite, reference_identity: identite_pivot) }

  let(:identite) do
    {
      annee_date_naissance: 1955,
      mois_date_naissance: 12,
      jour_date_naissance: 8
    }
  end
  let(:identite_pivot) do
    {
      annee_date_naissance: 1955,
      mois_date_naissance: 12,
      jour_date_naissance: 8
    }
  end

  describe 'when birthdate matches completely' do
    it { is_expected.to be_a_success }

    it 'sets matchbirthdate matching to true' do
      expect(subject.matchings['matchbirthdate']).to be true
    end
  end

  describe 'when year does not match' do
    let(:identite) do
      {
        annee_date_naissance: 1960,
        mois_date_naissance: 12,
        jour_date_naissance: 8
      }
    end

    it { is_expected.to be_a_success }

    it 'sets matchbirthdate matching to false' do
      expect(subject.matchings['matchbirthdate']).to be false
    end
  end

  describe 'normalization' do
    let(:identite) do
      {
        annee_date_naissance: '1955',
        mois_date_naissance: '12',
        jour_date_naissance: '8'
      }
    end

    it 'matches string numbers with integers' do
      expect(subject.matchings['matchbirthdate']).to be true
    end
  end
end
