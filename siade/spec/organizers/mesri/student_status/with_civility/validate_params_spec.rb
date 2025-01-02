RSpec.describe MESRI::StudentStatus::WithCivility::ValidateParams, type: :validate_params do
  subject { described_class.call(params:) }

  let(:params) do
    {
      nom_naissance:,
      prenoms:,
      annee_date_naissance:,
      mois_date_naissance:,
      jour_date_naissance:,
      code_cog_insee_commune_naissance:,
      sexe_etat_civil:,
      token_id:
    }
  end

  let(:nom_naissance) { 'Dupont' }
  let(:prenoms) { ['Jean'] }
  let(:annee_date_naissance) { 2000 }
  let(:mois_date_naissance) { 1 }
  let(:jour_date_naissance) { 1 }
  let(:code_cog_insee_commune_naissance) { '99100' }
  let(:sexe_etat_civil) { 'M' }

  let(:token_id) { SecureRandom.uuid }

  context 'with valid attributes' do
    it { is_expected.to be_a_success }
  end

  context 'without birthday place' do
    let(:code_cog_insee_commune_naissance) { '' }

    it { is_expected.to be_a_success }
  end

  context 'with wrong birthday place' do
    let(:code_cog_insee_commune_naissance) { '9919A' }

    it { is_expected.to be_a_failure }
  end

  context 'without prenoms' do
    let(:prenoms) { [] }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
  end

  context 'without nom naissance' do
    let(:nom_naissance) { '' }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
  end

  context 'with invalid sexe etat civil' do
    let(:sexe_etat_civil) { 'lol' }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
  end

  context 'without sexe etat civil' do
    let(:sexe_etat_civil) { nil }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
  end

  context 'with invalid date de naissance' do
    let(:annee_date_naissance) { -2000 }
    let(:mois_date_naissance) { 14 }
    let(:jour_date_naissance) { 1 }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
  end
end
