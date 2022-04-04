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

  context 'when it is an another response' do
    let(:response) { instance_double(Net::HTTPBadGateway, code: '502') }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(ProviderUnknownError)) }
  end
end
