RSpec.describe CNAF::ValidateParams, type: :validate_params do
  subject { described_class.call(params:) }

  let(:params) do
    {
      prenoms:,
      gender:,
      code_pays_lieu_de_naissance:,
      code_insee_lieu_de_naissance:,
      annee_date_de_naissance:,
      mois_date_de_naissance:,
      jour_date_de_naissance:,
      user_id:,
      request_id:,
      recipient:
    }
  end

  let(:prenoms) { %w[jean] }
  let(:gender) { 'F' }
  let(:code_pays_lieu_de_naissance) { '99345' }
  let(:code_insee_lieu_de_naissance) { '12345' }
  let(:annee_date_de_naissance) { 1988 }
  let(:mois_date_de_naissance) { 2 }
  let(:jour_date_de_naissance) { 6 }
  let(:user_id) { valid_siret(:msa) }
  let(:request_id) { SecureRandom.uuid }
  let(:recipient) { valid_siret }

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
    let(:code_insee_lieu_de_naissance) { 'INSEE7' }

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
end
