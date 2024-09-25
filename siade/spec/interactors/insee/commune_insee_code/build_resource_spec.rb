RSpec.describe INSEE::CommuneINSEECode::BuildResource, type: :build_resource do
  subject(:organizer) { described_class.call(response:, params:) }

  describe 'with real http calls' do
    let(:response) { INSEE::Metadonnees::MakeRequest.call(params:, token:).response }
    let(:token) { INSEE::Authenticate.call.token }

    let(:params) do
      {
        nom_commune_naissance:,
        annee_date_naissance:,
        code_cog_insee_departement_naissance:
      }
    end

    let(:annee_date_naissance) { '2000' }
    let(:code_cog_insee_departement_naissance) { '75' }

    context 'with a response which has 1 result', vcr: { cassette_name: 'insee/metadonnees/one_result' } do
      let(:nom_commune_naissance) { 'Gennevilliers' }

      it { is_expected.to be_a_success }

      describe 'resource' do
        subject { organizer.bundled_data.data }

        it { is_expected.to be_a(Resource) }

        its(:code_insee) { is_expected.to eq('92036') }
      end
    end

    context 'with a response which has more than 2 results', vcr: { cassette_name: 'insee/metadonnees/multiple_results' } do
      let(:nom_commune_naissance) { 'La Rochette' }

      context 'with 05 as code_cog_insee_departement_naissance' do
        let(:code_cog_insee_departement_naissance) { '05' }

        describe 'resource' do
          subject { organizer.bundled_data.data }

          it { is_expected.to be_a(Resource) }

          its(:code_insee) { is_expected.to eq('05124') }
        end
      end

      context 'with 04 as code_cog_insee_departement_naissance' do
        let(:code_cog_insee_departement_naissance) { '04' }

        describe 'resource' do
          subject { organizer.bundled_data.data }

          it { is_expected.to be_a(Resource) }

          its(:code_insee) { is_expected.to eq('04170') }
        end
      end
    end
  end
end
