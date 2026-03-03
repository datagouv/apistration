RSpec.describe BanqueDeFrance::BilansEntreprise::ValidateResponse, type: :validate_response do
  subject { described_class.call(response:, provider_name: 'Banque de France') }

  context 'with real http response', vcr: { cassette_name: 'banque_de_france/bilans_entreprises/valid_siren' } do
    let(:response) { BanqueDeFrance::BilansEntreprise::MakeRequest.call(params: { siren: }).response }
    let(:siren) { valid_siren(:bilan_entreprise_bdf) }

    it { is_expected.to be_a_success }

    its(:errors) { is_expected.to be_empty }
  end

  context 'with built http response' do
    context 'with a http ok' do
      let(:response) { instance_double(Net::HTTPOK, code: '200', body:) }

      let(:body) { build_banque_de_france_response(json_body) }

      context 'when it is a valid payload with data' do
        let(:json_body) { open_payload_file('banque_de_france/bilans_entreprise_valid_data.json').read }

        it { is_expected.to be_a_success }

        its(:errors) { is_expected.to be_empty }
      end

      context 'when it is a payload without data and a not found code' do
        let(:json_body) { open_payload_file('banque_de_france/bilans_entreprise_no_data.json').read }

        it { is_expected.to be_a_failure }

        its(:errors) { is_expected.to include(instance_of(NotFoundError)) }
      end

      context 'when it is a 408 error' do
        let(:response) { instance_double(Net::HTTPRequestTimeout, code: '408', body: 'whatever') }

        it { is_expected.to be_a_failure }

        its(:errors) { is_expected.to include(instance_of(ProviderInternalServerError)) }
      end

      context 'when it is a payload without data and a 500 error code' do
        let(:json_body) do
          {
            'code-retour' => 500
          }.to_json
        end

        it { is_expected.to be_a_failure }

        its(:errors) { is_expected.to include(instance_of(ProviderInternalServerError)) }
      end
    end

    context 'with a http 500 error' do
      let(:response) { instance_double(Net::HTTPInternalServerError, code: '500', body: '{"status":500,"error":"Internal Server Error"}') }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(ProviderInternalServerError)) }
    end

    context 'with an unknown error' do
      let(:response) { instance_double(Net::HTTPBadRequest, code: '400') }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(ProviderUnknownError)) }
    end
  end
end
