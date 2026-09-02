RSpec.describe RenderedError, type: :service do
  describe '.capture' do
    subject(:captured) { Current.rendered_error }

    context 'with a collection of errors' do
      before do
        described_class.capture([InvalidTokenError.new, BadRequestError.new])
      end

      it { is_expected.to be_a(InvalidTokenError) }
    end

    context 'with a single error' do
      before do
        described_class.capture(BadRequestError.new)
      end

      it { is_expected.to be_a(BadRequestError) }
    end

    context 'when an error has already been captured' do
      before do
        described_class.capture(InvalidTokenError.new)
        described_class.capture(BadRequestError.new)
      end

      it { is_expected.to be_a(InvalidTokenError) }
    end
  end

  describe '.log_fields' do
    subject(:log_fields) { described_class.log_fields }

    context 'without captured error' do
      it { is_expected.to eq({}) }
    end

    context 'with a provider error' do
      before do
        described_class.capture(ProviderUnknownError.new('CIBTP'))
      end

      it do
        expect(log_fields).to eq(
          error_code: '38999',
          error_provider_code: '38',
          error_subcode: '999'
        )
      end
    end

    context 'with a fixed code error' do
      before do
        described_class.capture(InvalidTokenError.new)
      end

      it do
        expect(log_fields).to eq(
          error_code: '00101',
          error_provider_code: '00',
          error_subcode: '101'
        )
      end
    end

    context 'when the code cannot be computed' do
      before do
        described_class.capture(ProviderUnknownError.new('unknown provider'))
      end

      it { is_expected.to eq({}) }
    end
  end
end
