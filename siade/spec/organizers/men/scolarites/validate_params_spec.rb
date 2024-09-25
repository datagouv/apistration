RSpec.describe MEN::Scolarites::ValidateParams, type: :validate_params do
  subject { described_class.call(params:) }

  let(:params) do
    {
      nom_naissance:,
      prenoms:,
      sexe_etat_civil:,
      annee_date_naissance:,
      mois_date_naissance:,
      jour_date_naissance:,
      code_etablissement:,
      annee_scolaire:
    }
  end

  let(:nom_naissance) { 'Dupont' }
  let(:prenoms) { ['Jean'] }
  let(:sexe_etat_civil) { 'm' }
  let(:annee_date_naissance) { '2000' }
  let(:mois_date_naissance) { '01' }
  let(:jour_date_naissance) { '01' }
  let(:code_etablissement) { '1234567w' }
  let(:annee_scolaire) { '2022' }

  context 'with valid attributes' do
    it { is_expected.to be_a_success }
  end

  context 'with missing nom_naissance' do
    let(:nom_naissance) { '' }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
  end

  context 'without prenoms' do
    let(:prenoms) { [] }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
  end

  context 'without code_etablissement' do
    let(:code_etablissement) { '' }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
  end

  context 'with invalid annee_scolaire' do
    let(:annee_scolaire) { 'lol' }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
  end

  context 'with invalid sexe_etat_civil' do
    let(:sexe_etat_civil) { 'lol' }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
  end

  context 'with invalid jour_date_naissance' do
    let(:jour_date_naissance) { 'lol' }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
  end
end
