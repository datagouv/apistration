RSpec.describe DGFIP::SituationIR::ValidateResponse, type: :validate_response do
  subject { described_class.call(response:, provider_name: 'DGFIP - SVAIR') }

  context 'with a http ok' do
    let(:response) { instance_double(Net::HTTPOK, code: '200') }

    it { is_expected.to be_a_success }

    its(:errors) { is_expected.to be_empty }
  end

  context 'with a not found response' do
    let(:response) { instance_double(Net::HTTPNotFound, code: '404') }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(NotFoundError)) }
  end

  context 'with a forbidden response' do
    let(:response) { instance_double(Net::HTTPForbidden, code: '403') }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(NotFoundError)) }
  end

  context 'with a gone response' do
    let(:response) { instance_double(Net::HTTPNotFound, code: '410') }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(NotFoundError)) }
  end

  context 'with an unknown error' do
    let(:response) { instance_double(Net::HTTPBadRequest, code: '400') }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(ProviderUnknownError)) }
  end

  context 'with a 400 error and a body with "format SPI incorrect"' do
    let(:response) { instance_double(Net::HTTPBadRequest, code: '400', body:) }
    let(:body) do
      {
        erreur: {
          message: 'format SPI incorrect'
        }
      }.to_json
    end

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
  end
end
