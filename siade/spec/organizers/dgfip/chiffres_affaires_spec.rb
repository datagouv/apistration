RSpec.describe DGFIP::ChiffresAffaires, type: :retriever_organizer do
  subject { described_class.call(params:) }

  let(:params) do
    {
      siret:,
      user_id:
    }
  end

  let(:user_id) { yes_jwt_user.id }

  describe 'with valid attributes', vcr: { cassette_name: 'dgfip/chiffres_affaires/valid' } do
    let(:siret) { valid_siret(:exercice) }

    it { is_expected.to be_a_success }

    its(:resource_collection) { is_expected.to be_present }
    its(:meta) { is_expected.to be_present }
    its(:cacheable) { is_expected.to be(true) }
  end

  context 'with a non existent siret', vcr: { cassette_name: 'dgfip/chiffres_affaires/not_found' } do
    let(:siret) { non_existent_siret }

    it { is_expected.to be_a_failure }

    its(:cacheable) { is_expected.to be(false) }
  end
end
