RSpec.describe INPI::RNE::Company::ValidateResponse, type: :validate_response do
  subject { described_class.call(response:, provider_name: 'INPI - RNE') }

  context 'with a http ok' do
    let(:response) { instance_double(Net::HTTPOK, code: '200', body:) }

    context 'when body is a valid json' do
      let(:body) { json_body }
      let(:json_body) { read_payload_file('inpi/rne/extrait_rne/valid.json') }

      it { is_expected.to be_a_success }

      its(:errors) { is_expected.to be_empty }
    end
  end

  context 'with a http not found' do
    let(:response) { instance_double(Net::HTTPNotFound, code: '404') }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(NotFoundError)) }
  end

  context 'with an unknown http code' do
    let(:response) { instance_double(Net::HTTPForbidden, code: '403') }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(ProviderUnknownError)) }
  end
end
