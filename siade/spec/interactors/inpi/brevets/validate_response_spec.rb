RSpec.describe INPI::Brevets::ValidateResponse, type: :validate_response do
  subject { described_class.call(response: response, provider_name: 'INPI') }

  let(:response) do
    instance_double('Net::HTTPOK', code: code, body: body)
  end

  describe 'with an invalid code' do
    let(:code) { '500' }
    let(:body) do
      {
        results: ['Some result']
      }.to_json
    end

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(ProviderInternalServerError)) }
  end

  context 'with a valid code and a body with results' do
    let(:code) { '200' }
    let(:body) do
      {
        results: ['Some result']
      }.to_json
    end

    it { is_expected.to be_a_success }

    its(:errors) { is_expected.to be_empty }
  end

  context 'with a valid code and a body with no results' do
    let(:code) { '200' }
    let(:body) do
      {
        results: []
      }.to_json
    end

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(NotFoundError)) }
  end

  context 'with a valid code and a body containing nonsense' do
    let(:code) { '200' }
    let(:body) { 'Nonsense' }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(ProviderUnknownError)) }
  end
end
