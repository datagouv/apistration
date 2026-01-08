RSpec.describe ProxyFileError, type: :error do
  it_behaves_like 'a valid error' do
    let(:instance) { described_class.new(:forbidden) }
  end

  describe '.from_http_status' do
    subject { described_class.from_http_status(status_code) }

    context 'with handled status codes' do
      %w[403 429 500 502 503 504].each do |code|
        context "with #{code}" do
          let(:status_code) { code }

          it { is_expected.to be_a(described_class) }
        end
      end
    end

    context 'with unhandled status code' do
      let(:status_code) { '418' }

      it { is_expected.to be_nil }
    end
  end

  describe '#http_status' do
    subject { described_class.new(:forbidden).http_status }

    it { is_expected.to eq(:bad_gateway) }
  end
end
