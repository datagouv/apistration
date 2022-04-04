RSpec.describe DGFIP::LiassesFiscales::Declarations, type: :retriever_organizer do
  subject { described_class.call(params:) }

  let(:params) do
    {
      siren:,
      year: annee,
      user_id:
    }
  end

  let(:user_id) { yes_jwt_user.id }
  let(:siren) { valid_siren(:liasse_fiscale) }
  let(:annee) { 2017 }

  context 'with valid attributes', vcr: { cassette_name: 'dgfip/liasses_fiscales/valid' } do
    it { is_expected.to be_a_success }

    its(:resource) { is_expected.to be_present }
  end

  context 'with a non existent siren', vcr: { cassette_name: 'dgfip/liasses_fiscales/with_non_existent_siren' } do
    let(:siren) { non_existent_siren }

    it { is_expected.to be_a_failure }
  end
end
