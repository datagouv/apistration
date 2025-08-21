RSpec.describe MatchIdentity::MatchCommune do
  subject { described_class.call(candidate_identity: identite, reference_identity: identite_pivot) }

  let(:identite) { { code_departement_naissance: '59' } }
  let(:identite_pivot) { { code_cog_insee_commune_naissance: '59001' } }

  describe 'when commune matches (starts with department code)' do
    it { is_expected.to be_a_success }

    it 'sets matchcommune matching to true' do
      expect(subject.matchings['matchcommune']).to be true
    end
  end

  describe 'when commune does not match' do
    let(:identite_pivot) { { code_cog_insee_commune_naissance: '62001' } }

    it { is_expected.to be_a_success }

    it 'sets matchcommune matching to false' do
      expect(subject.matchings['matchcommune']).to be false
    end
  end

  describe 'when department code is missing' do
    let(:identite) { { code_departement_naissance: nil } }

    it { is_expected.to be_a_success }

    it 'sets matchcommune matching to false' do
      expect(subject.matchings['matchcommune']).to be false
    end
  end
end
