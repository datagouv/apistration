RSpec.describe MatchIdentity::MatchSexe do
  subject { described_class.call(candidate_identity: identite, reference_identity: identite_pivot) }

  let(:identite) { { sexe_etat_civil: 'M' } }
  let(:identite_pivot) { { sexe_etat_civil: 'M' } }

  describe 'when sexe matches' do
    it { is_expected.to be_a_success }

    it 'sets matchsexe matching to true' do
      expect(subject.matchings['matchsexe']).to be true
    end
  end

  describe 'when sexe does not match' do
    let(:identite) { { sexe_etat_civil: 'F' } }

    it { is_expected.to be_a_success }

    it 'sets matchsexe matching to false' do
      expect(subject.matchings['matchsexe']).to be false
    end
  end
end
