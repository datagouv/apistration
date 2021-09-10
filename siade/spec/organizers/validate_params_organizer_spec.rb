RSpec.describe ValidateParamsOrganizer, type: :organizer do
  before(:all) do
    class DummyValidateAttributePresence < ValidateAttributePresence
      def attribute
        :month
      end
    end

    class DummyValidateParamsOrganizer < ValidateParamsOrganizer
      before do
        context.before = true
      end

      after do
        context.after = true
      end

      organize ValidateSiren,
        DummyValidateAttributePresence
    end
  end

  describe '.call' do
    subject { DummyValidateParamsOrganizer.call(params: params) }

    let(:params) do
      {
        siren: siren,
        month: dummy
      }.compact
    end

    let(:siren) { valid_siren }
    let(:dummy) { 'Here' }

    it 'executes both before and after callbacks' do
      expect(subject.before).to be_present
      expect(subject.after).to be_present
    end

    context 'with valid arguments' do
      it { is_expected.to be_a_success }
    end

    context 'with 2 invalid arguments' do
      let(:siren) { invalid_siren }
      let(:dummy) { nil }

      it { is_expected.to be_a_failure }

      it 'has 2 errors' do
        expect(subject.errors.count).to eq 2
      end
    end

    context 'with invalid siren' do
      let(:siren) { invalid_siren }

      it { is_expected.to be_a_failure }

      it 'has 1 error' do
        expect(subject.errors.count).to eq 1
      end
    end

    context 'with invalid dummy attribute' do
      let(:dummy) { nil }

      it { is_expected.to be_a_failure }

      it 'has 1 error' do
        expect(subject.errors.count).to eq 1
      end
    end
  end
end
