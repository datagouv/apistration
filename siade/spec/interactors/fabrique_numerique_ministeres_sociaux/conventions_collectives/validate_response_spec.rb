RSpec.describe FabriqueNumeriqueMinisteresSociaux::ConventionsCollectives::ValidateResponse, type: :validate_response do
  subject { described_class.call(response:, provider_name: 'Fabrique numérique des Ministères Sociaux') }

  context 'with a http ok' do
    context 'when it is a json' do
      let(:response) { FabriqueNumeriqueMinisteresSociaux::ConventionsCollectives::MakeRequest.call(params:).response }
      let(:params) do
        {
          siret:
        }
      end

      context 'when conventions key has at least one element' do
        let(:siret) { valid_siret(:conventions_collectives) }

        # `around` (not `before`) so the stub is registered ahead of the
        # `config.before(type: :validate_response)` hook, which forces `response`
        # to be evaluated (and thus the real HTTP call to fire) before any
        # example-level `before(:each)` hook would run.
        around do |example|
          stub_fabrique_numerique_conventions_collectives_valid
          example.run
        end

        it { is_expected.to be_a_success }

        its(:errors) { is_expected.to be_empty }
      end

      context 'when conventions key has no element' do
        let(:siret) { not_found_siret(:conventions_collectives) }

        around do |example|
          stub_fabrique_numerique_conventions_collectives_not_found
          example.run
        end

        it { is_expected.to be_a_failure }

        its(:errors) { is_expected.to include(instance_of(NotFoundError)) }
      end
    end

    context 'when it is not a json' do
      let(:response) { instance_double(Net::HTTPOK, code: '200', body: 'lol') }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(ProviderUnknownError)) }
    end
  end

  context 'with a not found response' do
    let(:response) { instance_double(Net::HTTPNotFound, code: '404') }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(NotFoundError)) }
  end

  context 'with an unknown error' do
    let(:response) { instance_double(Net::HTTPBadRequest, code: '400') }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(ProviderUnknownError)) }
  end
end
