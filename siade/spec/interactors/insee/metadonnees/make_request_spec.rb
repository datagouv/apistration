RSpec.describe INSEE::Metadonnees::MakeRequest, type: :make_request do
  describe '.call' do
    subject { described_class.call(params:, token:) }

    let(:params) do
      {
        nom_commune_naissance:,
        annee_date_de_naissance:
      }
    end

    let(:token) { INSEE::Authenticate.call.token }

    let(:annee_date_de_naissance) { '2000' }

    context 'with valid params which leads to 1 result', vcr: { cassette_name: 'insee/metadonnees/one_result' } do
      let(:nom_commune_naissance) { 'Gennevilliers' }

      it { is_expected.to be_a_success }

      its(:response) { is_expected.to be_a(Net::HTTPOK) }
    end

    context 'with invalid params which leads to no result', vcr: { cassette_name: 'insee/metadonnees/no_result' } do
      let(:nom_commune_naissance) { 'invalid' }

      it { is_expected.to be_a_success }

      its(:response) { is_expected.to be_a(Net::HTTPNotFound) }
    end

    context 'with valid params which leads to more than 1 result', vcr: { cassette_name: 'insee/metadonnees/multiple_results' } do
      let(:nom_commune_naissance) { 'La Rochette' }

      it { is_expected.to be_a_success }

      its(:response) { is_expected.to be_a(Net::HTTPOK) }
    end
  end
end
