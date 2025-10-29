RSpec.describe MatchIdentity::GivenName do
  subject { described_class.call(candidate_identity:, reference_identity:) }

  let(:candidate_identity) { { prenoms: ['JEAN'] } }
  let(:reference_identity) { { prenoms: ['JEAN'] } }

  describe 'when prenoms match' do
    it { is_expected.to be_a_success }

    it 'sets givenname matching to true' do
      expect(subject.matchings['givenname']).to be true
    end
  end

  describe 'when prenoms do not match' do
    let(:candidate_identity) { { prenoms: ['PAUL'] } }

    it { is_expected.to be_a_success }

    it 'sets givenname matching to false' do
      expect(subject.matchings['givenname']).to be false
    end
  end

  describe 'normalization' do
    let(:candidate_identity) { { prenoms: 'jean' } }
    let(:reference_identity) { { prenoms: 'JEAN' } }

    it 'matches case-insensitively' do
      expect(subject.matchings['givenname']).to be true
    end

    context 'with array vs string' do
      let(:candidate_identity) { { prenoms: 'JEAN' } }
      let(:reference_identity) { { prenoms: %w[Jean Martin] } }

      it 'matches when string is in array' do
        expect(subject.matchings['givenname']).to be true
      end
    end
  end

  describe 'asymetric composed name matching' do
    context 'when candidate match with a composed name in reference' do
      let(:candidate_identity) { { prenoms: ['PAUL'] } }
      let(:reference_identity) { { prenoms: %w[JEAN-PAUL-MARIE,PASCAL JACQUES] } }

      it 'matches' do
        expect(subject.matchings['givenname']).to be true
      end
    end

    context 'when candidate match with a single name in reference' do
      let(:candidate_identity) { { prenoms: ['JACQUES'] } }
      let(:reference_identity) { { prenoms: %w[JEAN-PAUL JACQUES] } }

      it 'matches' do
        expect(subject.matchings['givenname']).to be true
      end
    end

    context 'when reference match with a single name in candidate' do
      let(:candidate_identity) { { prenoms: ['JEAN-PAUL'] } }
      let(:reference_identity) { { prenoms: ['JEAN'] } }

      it 'does not match this way' do
        expect(subject.matchings['givenname']).to be false
      end
    end

    context 'when candidate has composed given name matching reference' do
      let(:candidate_identity) { { prenoms: ['JEAN-PHILIPPE'] } }
      let(:reference_identity) { { prenoms: %w[Jean-Philippe] } }

      it 'matches' do
        expect(subject.matchings['givenname']).to be true
      end
    end
  end
end
