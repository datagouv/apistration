RSpec.describe MEN::Scolarites::ValidateParams, type: :validate_params do
  subject { described_class.call(params:) }

  let(:params) do
    {
      family_name:,
      first_name:,
      gender:,
      birth_date:,
      code_etablissement:,
      annee_scolaire:
    }
  end

  let(:family_name) { 'Dupont' }
  let(:first_name) { 'Jean' }
  let(:gender) { 'm' }
  let(:birth_date) { '2000-01-01' }
  let(:code_etablissement) { '1234567w' }
  let(:annee_scolaire) { '2022' }

  let(:token_id) { SecureRandom.uuid }

  context 'with valid attributes' do
    it { is_expected.to be_a_success }
  end

  context 'with missing family name' do
    let(:family_name) { '' }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
  end

  context 'without first name' do
    let(:first_name) { '' }

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

  context 'with invalid gender' do
    let(:gender) { 'lol' }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
  end

  context 'with invalid birthday date' do
    let(:birth_date) { 'lol' }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
  end
end
