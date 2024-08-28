RSpec.describe INSEE::CommuneINSEECode::ValidateParams, type: :validate_params do
  subject { described_class.call(params:) }

  let(:params) do
    {
      nom_commune_naissance:,
      annee_date_de_naissance:,
      code_cog_insee_departement_de_naissance:
    }
  end

  let(:nom_commune_naissance) { 'Gennevilliers' }
  let(:annee_date_de_naissance) { '2000' }
  let(:code_cog_insee_departement_de_naissance) { '92' }

  context 'with valid params' do
    it { is_expected.to be_success }
  end

  context 'with empty nom commune naissance' do
    let(:nom_commune_naissance) { '' }

    it { is_expected.to be_failure }
  end

  context 'with invalid annee date de naissance' do
    let(:annee_date_de_naissance) { '2100' }

    it { is_expected.to be_failure }
  end

  context 'with invalid departement code' do
    let(:code_cog_insee_departement_de_naissance) { '999' }

    it { is_expected.to be_failure }
  end
end
