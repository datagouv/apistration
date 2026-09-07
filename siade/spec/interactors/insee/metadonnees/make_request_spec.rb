RSpec.describe INSEE::Metadonnees::MakeRequest, type: :make_request do
  describe '.call' do
    subject { described_class.call(params:) }

    let(:params) do
      {
        nom_commune_naissance:,
        annee_date_naissance:
      }
    end

    let(:annee_date_naissance) { '2000' }

    context 'with valid params which leads to 1 result' do
      let(:nom_commune_naissance) { 'Gennevilliers' }

      before { stub_insee_metadonnees_one_result }

      it { is_expected.to be_a_success }

      its(:response) { is_expected.to be_a(Net::HTTPOK) }
    end

    context 'with invalid params which leads to no result' do
      let(:nom_commune_naissance) { 'invalid' }

      before { stub_insee_metadonnees_no_result }

      it { is_expected.to be_a_success }

      its(:response) { is_expected.to be_a(Net::HTTPNotFound) }
    end

    context 'with valid params which leads to more than 1 result' do
      let(:nom_commune_naissance) { 'La Rochette' }

      before { stub_insee_metadonnees_multiple_results }

      it { is_expected.to be_a_success }

      its(:response) { is_expected.to be_a(Net::HTTPOK) }
    end
  end
end
