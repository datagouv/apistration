RSpec.describe GIPMDS::ServiceCivique::ValidateParams, type: :validate_params do
  subject { described_class.call(params:) }

  let(:params) do
    {
      nom_naissance:,
      prenoms:,
      annee_date_naissance:,
      mois_date_naissance:,
      jour_date_naissance:
    }
  end

  let(:nom_naissance) { 'Dupont' }
  let(:prenoms) { ['Jean'] }
  let(:annee_date_naissance) { 2000 }
  let(:mois_date_naissance) { 1 }
  let(:jour_date_naissance) { 15 }

  context 'with valid attributes' do
    it { is_expected.to be_a_success }
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

  context 'with invalid date de naissance' do
    let(:jour_date_naissance) { 32 }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
  end
end
