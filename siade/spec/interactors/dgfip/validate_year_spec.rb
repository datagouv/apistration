RSpec.describe DGFIP::ValidateYear, type: :validate_param_interactor do
  describe '#call' do
    subject { described_class.call(params:) }

    let(:params) do
      {
        year:
      }.compact
    end

    shared_examples 'year badly formatted' do
      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }

      it 'returns format error code (non-regression)' do
        expect(subject.errors.first.code).to eq('00307')
      end
    end

    shared_examples 'year out of range' do
      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }

      it 'returns range error code (non-regression)' do
        expect(subject.errors.first.code).to eq('00315')
      end
    end

    context 'when year is valid' do
      let(:year) { '2020' }

      it { is_expected.to be_a_success }
    end

    context 'when year is a valid integer' do
      let(:year) { 2020 }

      it { is_expected.to be_a_success }
    end

    context 'when it is nil' do
      it_behaves_like 'year badly formatted' do
        let(:year) { nil }
      end
    end

    context 'when it is not an integer' do
      it_behaves_like 'year badly formatted' do
        let(:year) { 'lol' }
      end
    end

    context 'when it is in the future' do
      it_behaves_like 'year out of range' do
        let(:year) { (Time.zone.today.year + 1).to_s }
      end
    end

    context 'when it is too far in the past' do
      it_behaves_like 'year out of range' do
        let(:year) { '1969' }
      end
    end
  end
end
