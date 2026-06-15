RSpec.describe DGFIP::TVA::ValidateResponse, type: :validate_response do
  subject { described_class.call(response:, provider_name: 'DGFIP - TVA') }

  context 'with a 200 OK and a json body containing data' do
    let(:response) { instance_double(Net::HTTPOK, code: '200', body:) }
    let(:body) { { data: [{ vat_no: '72217500016' }] }.to_json }

    it { is_expected.to be_a_success }
    its(:errors) { is_expected.to be_empty }
    its(:cacheable) { is_expected.to be(true) }
  end

  context 'with a 200 OK and an empty data array (TVA not found)' do
    let(:response) { instance_double(Net::HTTPOK, code: '200', body:) }
    let(:body) { { data: [], meta: { total: 0 } }.to_json }

    it { is_expected.to be_a_failure }
    its(:errors) { is_expected.to include(an_instance_of(NotFoundError)) }
    its(:cacheable) { is_expected.to be(true) }
  end

  context 'with a 200 OK and a body that is not JSON' do
    let(:response) { instance_double(Net::HTTPOK, code: '200', body: 'not json') }

    it { is_expected.to be_a_failure }
    its(:errors) { is_expected.to include(an_instance_of(ProviderUnknownError)) }
  end

  context 'with a 200 OK and a json body without a data key' do
    let(:response) { instance_double(Net::HTTPOK, code: '200', body: { foo: 'bar' }.to_json) }

    it { is_expected.to be_a_failure }
    its(:errors) { is_expected.to include(an_instance_of(ProviderUnknownError)) }
  end

  context 'with a 404 (bad resource id - ops problem, not data problem)' do
    let(:response) { instance_double(Net::HTTPNotFound, code: '404', body: '404: Not Found') }

    it { is_expected.to be_a_failure }
    its(:errors) { is_expected.to include(an_instance_of(ProviderUnavailable)) }
  end

  context 'with an unknown error' do
    let(:response) { instance_double(Net::HTTPBadRequest, code: '400', body: '{"errors":[]}') }

    it { is_expected.to be_a_failure }
    its(:errors) { is_expected.to include(an_instance_of(ProviderUnknownError)) }
  end
end
