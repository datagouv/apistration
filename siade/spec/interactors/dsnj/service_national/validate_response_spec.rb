RSpec.describe DSNJ::ServiceNational::ValidateResponse, type: :validate_response do
  subject { described_class.call(response:, provider_name: 'DSNJ') }

  context 'with a http ok and a return code ok' do
    let(:response) { instance_double(Net::HTTPOK, code: 200, body:) }

    context 'with a response specifying FOUND' do
      let(:body) { read_payload_file('dsnj/service_national/found.json') }

      it { is_expected.to be_success }

      its(:errors) { is_expected.to be_empty }
    end

    context 'with a response specifying NOT_FOUND' do
      let(:body) { read_payload_file('dsnj/service_national/not_found.json') }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(NotFoundError)) }
    end
  end

  context 'with an http not ok' do
    let(:response) { instance_double(Net::HTTPInternalServerError, code: 500, body:) }
    let(:body) { read_payload_file('dsnj/service_national/ko.json') }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(ProviderUnknownError)) }
  end

  context 'with a return code not ok' do
    let(:response) { instance_double(Net::HTTPOK, code: 200, body:) }
    let(:body) { read_payload_file('dsnj/service_national/error_with_return_code_ok.json') }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(ProviderUnknownError)) }
  end

  context 'with more than one result' do
    let(:response) { instance_double(Net::HTTPOK, code: 200, body:) }
    let(:body) { read_payload_file('dsnj/service_national/found_multiple.json') }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(ProviderUnknownError)) }
  end
end
