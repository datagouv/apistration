RSpec.describe ValidateYear, type: :validate_param_interactor do
  describe '#call' do
    subject { described_class.call(params:) }

    let(:params) do
      {
        year:
      }.compact
    end

    shared_examples 'year not valid' do
      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
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
      it_behaves_like 'year not valid' do
        let(:year) { nil }
      end
    end

    context 'when it is not an integer' do
      it_behaves_like 'year not valid' do
        let(:year) { 'lol' }
      end
    end

    context 'when it is in the future' do
      it_behaves_like 'year not valid' do
        let(:year) { (Time.zone.today.year + 1).to_s }
      end
    end

    context 'when it is too far in the past' do
      it_behaves_like 'year not valid' do
        let(:year) { '1801' }
      end
    end
  end
end
