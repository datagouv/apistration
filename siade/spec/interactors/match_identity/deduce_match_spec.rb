RSpec.describe MatchIdentity::DeduceMatch do
  subject { described_class.call(context) }

  let(:context) do
    {
      matchings: {
        'familyname' => name_matches,
        'givenname' => prenoms_matches,
        'matchsexe' => sexe_matches,
        'matchbirthdate' => birthdate_matches,
        'matchcommune' => commune_matches
      }
    }
  end

  describe 'when familyname and givenname match' do
    let(:name_matches) { true }
    let(:prenoms_matches) { true }
    let(:sexe_matches) { true }
    let(:birthdate_matches) { true }
    let(:commune_matches) { true }

    it { is_expected.to be_a_success }

    it 'sets matches to true' do
      expect(subject.matches).to be true
    end
  end

  describe 'when familyname and givenname match but birthdate does not' do
    let(:name_matches) { true }
    let(:prenoms_matches) { true }
    let(:sexe_matches) { true }
    let(:birthdate_matches) { false }
    let(:commune_matches) { true }

    it { is_expected.to be_a_success }

    it 'sets matches to true (birthdate is no longer required)' do
      expect(subject.matches).to be true
    end
  end
end
