RSpec.describe INSEE::CommuneINSEECode, type: :retriever_organizer do
  subject { described_class.call(params:) }

  let(:params) do
    {
      nom_commune_naissance:,
      annee_date_de_naissance:,
      code_insee_departement_de_naissance:
    }
  end

  let(:nom_commune_naissance) { 'Gennevilliers' }
  let(:annee_date_de_naissance) { '2000' }
  let(:code_insee_departement_de_naissance) { '92' }

  describe 'with valid attributes', vcr: { cassette_name: 'insee/metadonnees/one_result' } do
    it { is_expected.to be_a_success }

    it 'retrieves the resource' do
      resource = subject.bundled_data.data

      expect(resource).to be_present
      expect(resource.code_insee).to eq('92036')
    end
  end

  describe 'with an invalid params' do
    let(:annee_date_de_naissance) { 'invalid' }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
  end
end
