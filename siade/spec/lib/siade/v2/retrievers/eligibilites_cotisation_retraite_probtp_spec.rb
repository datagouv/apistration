RSpec.describe SIADE::V2::Retrievers::EligibilitesCotisationRetraitePROBTP do
  subject { described_class.new(valid_siret(:probtp)) }

  let(:one_and_only_driver) { SIADE::V2::Drivers::EligibilitesCotisationRetraitePROBTP }

  it { is_expected.to be_delegated_to(one_and_only_driver, :eligible?) }
  it { is_expected.to be_delegated_to(one_and_only_driver, :message) }
  it { is_expected.to be_delegated_to(one_and_only_driver, :http_code) }
end
