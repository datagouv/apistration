RSpec.describe MSA::ConformitesCotisations::ValidateResponse, type: :validate_response do
  subject { described_class.call(response:) }

  let(:siret) { valid_siret(:msa) }

  context 'when it is a HTTP ok response' do
    let(:response) { instance_double(Net::HTTPOK, code: '200', body:) }

    context 'when body contains a status which is not unknown' do
      let(:body) { msa_cotisations_payload(siret, :up_to_date).to_json }

      it { is_expected.to be_a_success }
    end

    context 'when body contains a status which is unknown' do
      let(:body) { msa_cotisations_payload(siret, :unknown).to_json }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(NotFoundError)) }
    end

    context 'when body contains a status which is not specified' do
      let(:body) { msa_cotisations_payload(siret, 'oki', allow_another_status: true).to_json }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(ProviderUnknownError)) }
    end
  end

  context 'when it is a HTTP internal server error response' do
    let(:response) { instance_double(Net::HTTPInternalServerError, code: '500') }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(ProviderInternalServerError)) }
  end

  context 'when it is an another response' do
    let(:response) { instance_double(Net::HTTPBadGateway, code: '502', body:) }

    context 'when body contains a 502 Bad Gateway error' do
      let(:body) { msa_bad_gateway_payload }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(ProviderInternalServerError)) }
    end

    context 'when body contains a 504 Gateway Timeout error' do
      let(:body) { msa_gateway_timeout_payload }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(ProviderInternalServerError)) }
    end

    context 'when body contains something else' do
      let(:body) { 'whatever' }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(ProviderUnknownError)) }
    end
  end
end
