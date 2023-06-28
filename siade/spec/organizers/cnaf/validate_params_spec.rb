RSpec.describe CNAF::ValidateParams, type: :validate_params do
  subject { described_class.call(params:) }

  let(:params) do
    {
      gender:,
      code_pays_lieu_de_naissance:,
      code_insee_lieu_de_naissance:,
      annee_date_de_naissance:,
      mois_date_de_naissance:,
      jour_date_de_naissance:,
      user_siret:,
      request_id:
    }
  end

  let(:gender) { 'F' }
  let(:code_pays_lieu_de_naissance) { '99345' }
  let(:code_insee_lieu_de_naissance) { '12345' }
  let(:annee_date_de_naissance) { 1988 }
  let(:mois_date_de_naissance) { 2 }
  let(:jour_date_de_naissance) { 6 }
  let(:user_siret) { valid_siret(:msa) }
  let(:request_id) { SecureRandom.uuid }

  context 'with valid attributes' do
    it { is_expected.to be_a_success }
  end

  context 'with invalid gender' do
    let(:gender) { 'nope' }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
  end

  context 'with invalid code_pays_lieu_de_naissance' do
    let(:code_pays_lieu_de_naissance) { '123Q5' }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
  end

  context 'with invalid code_insee_lieu_de_naissance' do
    let(:code_insee_lieu_de_naissance) { 'INSEE' }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
  end

  context 'with invalid date de naissance' do
    context 'with invalid year' do
      let(:annee_date_de_naissance) { -1988 }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
    end

    context 'with invalid month' do
      let(:mois_date_de_naissance) { 30 }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
    end

    context 'with invalid day' do
      let(:jour_date_de_naissance) { 30 }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
    end
  end

  context 'with invalid request_id' do
    let(:request_id) { 'fblblbl' }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
  end
end
