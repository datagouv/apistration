RSpec.describe INSEE::Successions::ValidateResponse, type: :validate_response do
  subject { described_class.call(response:, provider_name: 'INSEE') }

  context 'with a http ok' do
    let(:response) { instance_double(Net::HTTPOK, code: '200', body: '{"successions":[]}') }

    it { is_expected.to be_a_success }

    its(:errors) { is_expected.to be_empty }
  end

  context 'with a http ok but HTML body' do
    let(:response) { instance_double(Net::HTTPOK, code: '200', body: '<!DOCTYPE html><html></html>', to_hash: {}) }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(ProviderUnknownError)) }
  end

  context 'with a not found response' do
    let(:response) { instance_double(Net::HTTPNotFound, code: '404') }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(NotFoundError)) }
  end

  context 'with a 500 error' do
    let(:response) { instance_double(Net::HTTPInternalServerError, code: '500') }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(ProviderInternalServerError)) }
  end

  context 'with an unknown error' do
    let(:response) { instance_double(Net::HTTPBadRequest, code: '400') }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(ProviderUnknownError)) }
  end
end
