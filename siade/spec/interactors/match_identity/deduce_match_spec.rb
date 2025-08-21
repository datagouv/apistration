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

  describe 'when all fields match' do
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

  describe 'when one field does not match' do
    let(:name_matches) { false }
    let(:prenoms_matches) { true }
    let(:sexe_matches) { true }
    let(:birthdate_matches) { true }
    let(:commune_matches) { true }

    it { is_expected.to be_a_failure }

    it 'sets matches to false' do
      expect(subject.matches).to be false
    end
  end
end
