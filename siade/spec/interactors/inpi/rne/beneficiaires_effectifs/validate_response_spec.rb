RSpec.describe INPI::RNE::BeneficiairesEffectifs::ValidateResponse, type: :validate_response do
  subject { described_class.call(response:, provider_name: 'INPI - RNE') }

  context 'with a http ok' do
    let(:response) { instance_double(Net::HTTPOK, code: '200', body:) }

    context 'when body is a valid json' do
      let(:body) { json_body }

      context 'when body is valid' do
        let(:json_body) { read_payload_file('inpi/rne/beneficiaires_effectifs/valid.json') }

        it { is_expected.to be_a_success }

        its(:errors) { is_expected.to be_empty }
      end

      context 'when body has no beneficiairesEffectifs within formality->content->personneMorale' do
        let(:json_body) { read_payload_file('inpi/rne/beneficiaires_effectifs/without-beneficiaires-effectifs.json') }

        it { is_expected.to be_a_failure }

        its(:errors) { is_expected.to include(instance_of(NotFoundError)) }
      end

      context 'when response is an entrepreneur individuel' do
        let(:json_body) { read_payload_file('inpi/rne/beneficiaires_effectifs/entrepreneur-individuel.json') }

        it { is_expected.to be_a_failure }

        its(:errors) { is_expected.to include(instance_of(NotFoundError)) }
      end

      context 'when response is nor a personne morale neither a personne physique' do
        let(:json_body) { read_payload_file('inpi/rne/beneficiaires_effectifs/nor_personne_morale_nor_personne_physique.json') }

        it { is_expected.to be_a_failure }

        its(:errors) { is_expected.to include(instance_of(NotFoundError)) }
      end
    end
  end

  context 'with a http not found' do
    let(:response) { instance_double(Net::HTTPNotFound, code: '404') }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(NotFoundError)) }
  end

  context 'with a 200 WAF response (invalid JSON)' do
    let(:response) { instance_double(Net::HTTPOK, code: '200', body: '<html>WAF blocked</html>') }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(ProviderUnavailable)) }
  end

  context 'with a 429 error' do
    let(:response) { instance_double(Net::HTTPTooManyRequests, code: '429') }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(ProviderRateLimitingError)) }
  end

  context 'with an unknown http code' do
    let(:response) { instance_double(Net::HTTPForbidden, code: '403') }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(ProviderUnknownError)) }
  end
end
