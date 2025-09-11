RSpec.describe MatchIdentity::GivenName do
  subject { described_class.call(candidate_identity: identite, reference_identity: identite_pivot) }

  let(:identite) { { prenoms: ['JEAN'] } }
  let(:identite_pivot) { { prenoms: ['JEAN'] } }

  describe 'when prenoms match' do
    it { is_expected.to be_a_success }

    it 'sets givenname matching to true' do
      expect(subject.matchings['givenname']).to be true
    end
  end

  describe 'when prenoms do not match' do
    let(:identite) { { prenoms: ['PAUL'] } }

    it { is_expected.to be_a_success }

    it 'sets givenname matching to false' do
      expect(subject.matchings['givenname']).to be false
    end
  end

  describe 'normalization' do
    let(:identite) { { prenoms: 'jean' } }
    let(:identite_pivot) { { prenoms: 'JEAN' } }

    it 'matches case-insensitively' do
      expect(subject.matchings['givenname']).to be true
    end

    context 'with array vs string' do
      let(:identite) { { prenoms: 'JEAN' } }
      let(:identite_pivot) { { prenoms: %w[Jean Martin] } }

      it 'matches when string is in array' do
        expect(subject.matchings['givenname']).to be true
      end
    end
  end

  describe 'asymetric composed name matching' do
    context 'when candidate match with a composed name in reference' do
      let(:identite) { { prenoms: ['JEAN'] } }
      let(:identite_pivot) { { prenoms: %w[JEAN-PAUL JACQUES] } }

      it 'matches' do
        expect(subject.matchings['givenname']).to be true
      end
    end

    context 'when candidate match with a single name in reference' do
      let(:identite) { { prenoms: ['JACQUES'] } }
      let(:identite_pivot) { { prenoms: %w[JEAN-PAUL JACQUES] } }

      it 'matches' do
        expect(subject.matchings['givenname']).to be true
      end
    end

    context 'when reference match with a single name in candidate' do
      let(:identite) { { prenoms: ['JEAN-PAUL'] } }
      let(:identite_pivot) { { prenoms: ['JEAN'] } }

      it 'does not match this way' do
        expect(subject.matchings['givenname']).to be false
      end
    end
  end
end
