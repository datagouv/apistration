RSpec.describe ValidateYear, type: :validate_param_interactor do
  describe '#call' do
    subject { described_class.call(params: params) }

    let(:params) do
      {
        year: year
      }
    end

    shared_examples 'year not valid' do
      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
    end

    context 'when year is valid' do
      let(:year) { '2020' }

      it { is_expected.to be_a_success }
    end

    context 'when it is not an integer' do
      include_examples 'year not valid' do
        let(:year) { 'lol' }
      end
    end

    context 'when it is in the future' do
      include_examples 'year not valid' do
        let(:year) { (Time.zone.today.year + 1).to_s }
      end
    end

    context 'when it is too far in the pas' do
      include_examples 'year not valid' do
        let(:year) { '1969' }
      end
    end
  end
end
