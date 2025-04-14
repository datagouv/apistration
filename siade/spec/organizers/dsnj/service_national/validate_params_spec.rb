RSpec.describe DSNJ::ServiceNational::ValidateParams, type: :validate_params do
  subject { described_class.call(params:) }

  let(:params) do
    {
      nom_naissance:,
      prenoms:,
      annee_date_naissance:,
      mois_date_naissance:,
      jour_date_naissance:,
      code_cog_insee_commune_naissance:,
      code_cog_insee_pays_naissance:,
      sexe_etat_civil:
    }
  end

  let(:nom_naissance) { 'SEKIRO' }
  let(:prenoms) { %w[Shinobi Wolf] }
  let(:annee_date_naissance) { 2008 }
  let(:mois_date_naissance) { 3 }
  let(:jour_date_naissance) { 22 }
  let(:code_cog_insee_commune_naissance) { '92036' }
  let(:code_cog_insee_pays_naissance) { '99100' }
  let(:sexe_etat_civil) { 'M' }

  context 'with valid attributes' do
    it { is_expected.to be_a_success }
  end

  context 'with invalid sexe_etat_civil' do
    let(:sexe_etat_civil) { 'nope' }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
  end

  describe 'with invalid code_cog_insee_pays_naissance' do
    let(:code_cog_insee_pays_naissance) { '123Q5' }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
  end

  describe 'with no prenoms' do
    let(:prenoms) { nil }

    it { is_expected.to be_a_failure }
  end

  describe 'with empty params for pays de naissance' do
    let(:code_cog_insee_pays_naissance) { nil }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
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
      let(:jour_date_naissance) { 300 }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
    end
  end

  context 'with invalid prenoms' do
    let(:prenoms) { 'Jean' }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
  end

  context 'with invalid nom_naissance' do
    let(:nom_naissance) { nil }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
  end
end
