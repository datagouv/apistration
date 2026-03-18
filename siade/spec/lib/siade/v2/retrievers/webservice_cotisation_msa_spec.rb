RSpec.describe SIADE::V2::Retrievers::CotisationsMSA do
  subject { described_class.new(valid_siret(:msa)) }

  let(:one_and_only_driver) { SIADE::V2::Drivers::CotisationsMSA }

  it { is_expected.to be_delegated_to(one_and_only_driver, :analyse_en_cours?) }
  it { is_expected.to be_delegated_to(one_and_only_driver, :a_jour?) }
  it { is_expected.to be_delegated_to(one_and_only_driver, :http_code) }
  it { is_expected.to be_delegated_to(one_and_only_driver, :errors) }
end
