RSpec.describe CNAV::QuotientFamilialV2::ValidateYear, type: :validate_param_interactor do
  describe '#call' do
    subject { described_class.call(params:) }

    let(:params) do
      {
        annee:
      }.compact
    end

    shared_examples 'year valid' do
      it { is_expected.to be_a_success }
    end

    context 'when it is nil' do
      it_behaves_like 'year valid' do
        let(:annee) { nil }
      end
    end

    context 'when year is a valid integer' do
      it_behaves_like 'year valid' do
        let(:annee) { Time.zone.today.year }
      end
    end

    shared_examples 'year not valid' do
      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }

      it 'error has correct error code (non-regression)' do
        expect(subject.errors.first.code).to eq('00353')
      end
    end

    context 'when it is not an integer' do
      it_behaves_like 'year not valid' do
        let(:annee) { 'lol' }
      end
    end

    context 'when it is in the future' do
      it_behaves_like 'year not valid' do
        let(:annee) { Time.zone.today.year + 1 }
      end
    end

    context 'when it is too far in the past' do
      it_behaves_like 'year not valid' do
        let(:annee) { 2021 }
      end
    end
  end
end
