RSpec.describe MESRI::StudentStatusWithINE::ValidateINE, type: :validate_param_interactor do
  subject { described_class.call(params: { ine: }) }

  context 'when attribute is missing' do
    let(:ine) { nil }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
  end

  context 'when attribute is present' do
    context 'when it is 11 alpha-numeric chars' do
      let(:ine) { '1234567890G' }

      it { is_expected.to be_a_success }

      its(:errors) { is_expected.to be_empty }
    end

    context 'when it is 11 non-alpha-numeric chars' do
      let(:ine) { '1234567]90G' }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
    end

    context 'when it is 10 alpha-numeric chars' do
      let(:ine) { '1234567890' }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
    end

    context 'when it is 12 alpha-numeric chars' do
      let(:ine) { '1234567890GG' }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
    end
  end
end
