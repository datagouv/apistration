RSpec.describe MatchIdentity::FamilyName do
  subject { described_class.call(candidate_identity: identite, reference_identity: identite_pivot) }

  let(:identite) { { nom_naissance: 'DUPONT' } }
  let(:identite_pivot) { { nom_naissance: 'DUPONT' } }

  describe 'when names match' do
    it { is_expected.to be_a_success }

    it 'sets familyname matching to true' do
      expect(subject.matchings['familyname']).to be true
    end
  end

  describe 'when names do not match' do
    let(:identite) { { nom_naissance: 'MARTIN' } }

    it { is_expected.to be_a_success }

    it 'sets familyname matching to false' do
      expect(subject.matchings['familyname']).to be false
    end
  end
end
