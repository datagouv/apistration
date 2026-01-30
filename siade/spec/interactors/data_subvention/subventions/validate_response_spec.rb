RSpec.describe DataSubvention::Subventions::ValidateResponse, type: :validate_response do
  subject { described_class.call(response:, provider_name: 'DataSubvention') }

  context 'with a http ok' do
    let(:response) { instance_double(Net::HTTPOK, code: '200', body:) }

    context 'when body is not a valid json' do
      let(:body) { 'lol' }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(ProviderUnknownError)) }
    end

    context 'when body is a json' do
      context 'when json a a "subventions" key empty' do
        let(:body) { { 'subventions' => [] }.to_json }

        it { is_expected.to be_a_failure }

        its(:errors) { is_expected.to include(instance_of(NotFoundError)) }
      end

      context 'with a valid json' do
        let(:body) { read_payload_file('data_subvention/subventions/valid.json') }

        it { is_expected.to be_a_success }

        its(:errors) { is_expected.to be_empty }
      end
    end
  end

  context 'with a not found response' do
    let(:response) { instance_double(Net::HTTPNotFound, code: '404') }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(NotFoundError)) }
  end

  context 'with an bad request error' do
    let(:response) { instance_double(Net::HTTPBadRequest, code: '400') }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(NotFoundError)) }
  end

  context 'with an unknown error' do
    let(:response) { instance_double(Net::HTTPBadRequest, code: '500') }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(ProviderUnknownError)) }
  end
end
