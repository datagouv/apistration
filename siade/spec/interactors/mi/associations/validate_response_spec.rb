RSpec.describe MI::Associations::ValidateResponse, type: :validate_response do
  describe '.call' do
    subject { described_class.call(response: response) }

    let(:response) do
      instance_double('Net::HTTPOK', code: code, body: body)
    end

    context 'with a valid code and a valid json' do
      let(:code) { '200' }
      let(:body) do
        {
          id: '1234567890',
        }.to_json
      end

      it { is_expected.to be_a_success }

      its(:errors) { is_expected.to be_empty }
    end

    context 'with a 404 code and whatever body' do
      let(:code) { '404' }
      let(:body) { 'whatever' }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(NotFoundError)) }
    end

    context 'with a valid code and an invalid json' do
      let(:code) { '200' }
      let(:body) do
        {
          lol: 'oki',
        }.to_json
      end

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(ProviderInternalServerError)) }
    end

    context 'with a valid code and an invalid body' do
      let(:code) { '200' }
      let(:body) { 'whatever' }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(ProviderInternalServerError)) }
    end

    context 'with an invalid status code' do
      let(:code) { '418' }
      let(:body) do
        {
          id: '123456789',
        }
      end

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(ProviderInternalServerError)) }
    end
  end
end
