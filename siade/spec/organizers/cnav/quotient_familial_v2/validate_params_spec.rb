RSpec.describe CNAV::QuotientFamilialV2::ValidateParams, type: :validate_params do
  subject { described_class.call(params:, recipient:) }

  let(:params) do
    {
      nom_naissance:,
      prenoms:,
      sexe_etat_civil:,
      code_cog_insee_pays_naissance:,

      code_cog_insee_commune_naissance:,
      nom_commune_naissance:,
      annee_date_naissance:,
      code_cog_insee_departement_naissance:,

      mois_date_naissance:,
      jour_date_naissance:,
      user_id:,
      request_id:,

      annee:,
      mois:
    }
  end

  let(:nom_naissance) { 'Bulbizare' }
  let(:prenoms) { %w[jean] }
  let(:sexe_etat_civil) { 'F' }
  let(:code_cog_insee_pays_naissance) { '99345' }

  let(:code_cog_insee_commune_naissance) { '12345' }
  let(:nom_commune_naissance) { nil }
  let(:code_cog_insee_departement_naissance) { nil }

  let(:annee_date_naissance) { 1988 }
  let(:mois_date_naissance) { 2 }
  let(:jour_date_naissance) { 6 }
  let(:user_id) { valid_siret(:msa) }
  let(:request_id) { SecureRandom.uuid }
  let(:recipient) { valid_siret }

  let(:annee) { 2024 }
  let(:mois) { 2 }

  describe 'with transcogage params' do
    let(:nom_commune_naissance) { 'Gennevilliers' }
    let(:code_cog_insee_commune_naissance) { nil }
    let(:code_cog_insee_pays_naissance) { '99100' }

    context 'when it is valid' do
      let(:code_cog_insee_departement_naissance) { '92' }

      it { is_expected.to be_a_success }
    end

    context 'when it is not valid' do
      let(:code_cog_insee_departement_naissance) { 'invalid' }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
    end
  end

  context 'with valid attributes' do
    it { is_expected.to be_a_success }
  end

  context 'with invalid sexe_etat_civil' do
    let(:sexe_etat_civil) { 'nope' }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
  end

  context 'with empty sexe_etat_civil' do
    let(:sexe_etat_civil) { nil }

    it { is_expected.to be_a_success }
  end

  context 'with invalid code_cog_insee_pays_naissance' do
    describe 'with invalid code_cog_insee_pays_naissance' do
      let(:code_cog_insee_pays_naissance) { '123Q5' }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
    end
  end

  describe 'non regression test' do
    describe 'with no prenoms' do
      let(:prenoms) { nil }

      it { is_expected.to be_a_success }
    end

    describe 'with empty params for lieu de naissance and in france' do
      let(:code_cog_insee_commune_naissance) { nil }
      let(:code_cog_insee_pays_naissance) { '99100' }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
    end

    describe 'with empty params for lieu de naissance and not in france' do
      let(:code_cog_insee_commune_naissance) { nil }
      let(:code_cog_insee_pays_naissance) { '99111' }

      it { is_expected.to be_a_success }

      its(:errors) { is_expected.to be_empty }
    end
  end

  context 'with invalid code_cog_insee_commune_naissance' do
    let(:code_cog_insee_commune_naissance) { 'INSEE7' }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
  end

  context 'with invalid date de naissance' do
    context 'with invalid year' do
      let(:annee_date_naissance) { -1988 }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
    end

    context 'with invalid month' do
      let(:mois_date_naissance) { 30 }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
    end

    context 'with invalid day' do
      let(:jour_date_naissance) { 30 }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
    end
  end

  context 'with invalid request_id' do
    let(:request_id) { 'fblblbl' }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
  end

  context 'with invalid prenoms' do
    let(:prenoms) { 'Jean' }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
  end

  context 'with invalid recipient' do
    let(:recipient) { 'not a siret' }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(InvalidRecipientError)) }
  end

  context 'with too ancient year' do
    let(:annee) { 2021 }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
  end

  context 'with invalid nom_naissance' do
    let(:nom_naissance) { nil }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
  end
end
