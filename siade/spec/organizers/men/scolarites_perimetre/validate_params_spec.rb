RSpec.describe MEN::ScolaritesPerimetre::ValidateParams, type: :validate_params do
  subject { described_class.call(params:) }

  let(:params) do
    {
      nom_naissance:,
      prenoms:,
      sexe_etat_civil:,
      annee_date_naissance:,
      mois_date_naissance:,
      jour_date_naissance:,
      annee_scolaire:,
      degre_etablissement:,
      codes_cog_insee_communes:,
      codes_bcn_departements:,
      codes_bcn_regions:,
      identifiants_siren_intercommunalites:
    }
  end

  let(:nom_naissance) { 'Dupont' }
  let(:prenoms) { ['Jean'] }
  let(:sexe_etat_civil) { 'm' }
  let(:annee_date_naissance) { '2000' }
  let(:mois_date_naissance) { '01' }
  let(:jour_date_naissance) { '01' }
  let(:annee_scolaire) { '2022' }
  let(:degre_etablissement) { '2D' }
  let(:codes_cog_insee_communes) { %w[75056] }
  let(:codes_bcn_departements) { nil }
  let(:codes_bcn_regions) { nil }
  let(:identifiants_siren_intercommunalites) { nil }

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

  context 'with invalid degre_etablissement' do
    let(:degre_etablissement) { '3D' }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
  end

  context 'with no perimetre' do
    let(:codes_cog_insee_communes) { nil }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
  end

  context 'with multiple perimetres' do
    let(:codes_bcn_departements) { %w[075] }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
  end
end
