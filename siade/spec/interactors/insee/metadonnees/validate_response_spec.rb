RSpec.describe INSEE::Metadonnees::ValidateResponse, type: :validate_response do
  subject { described_class.call(response:, provider_name: 'INSEE') }

  describe 'with real http calls' do
    let(:response) { INSEE::Metadonnees::MakeRequest.call(params:).response }

    let(:params) do
      {
        nom_commune_naissance:,
        annee_date_naissance:
      }
    end

    let(:annee_date_naissance) { '2000' }

    context 'with a response which has 1 result', vcr: { cassette_name: 'insee/metadonnees/one_result' } do
      let(:nom_commune_naissance) { 'Gennevilliers' }

      it { is_expected.to be_a_success }

      its(:errors) { is_expected.to be_empty }
    end

    context 'with a response which has 2 results', vcr: { cassette_name: 'insee/metadonnees/multiple_results' } do
      let(:nom_commune_naissance) { 'La Rochette' }

      it { is_expected.to be_a_success }

      its(:errors) { is_expected.to be_empty }
    end
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
    let(:response) { instance_double(Net::HTTPResponse, code: '418') }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(ProviderUnknownError)) }
  end
end
