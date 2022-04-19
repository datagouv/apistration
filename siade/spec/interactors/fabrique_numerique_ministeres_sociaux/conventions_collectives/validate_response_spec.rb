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

      context 'when conventions key has at least one element', vcr: { cassette_name: 'fabrique_numerique_ministeres_sociaux/conventions_collectives/valid_siret' } do
        let(:siret) { valid_siret(:conventions_collectives) }

        it { is_expected.to be_a_success }

        its(:errors) { is_expected.to be_empty }
      end

      context 'when conventions key has no element', vcr: { cassette_name: 'fabrique_numerique_ministeres_sociaux/conventions_collectives/not_found_siret' } do
        let(:siret) { not_found_siret(:conventions_collectives) }

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
