RSpec.describe SIADE::V2::Retrievers::ExtraitsRCSInfogreffe do
  subject { described_class.new(valid_siren(:extrait_rcs)) }
  let(:driver) { SIADE::V2::Drivers::Infogreffe }

  it { is_expected.to be_delegated_to(driver, :http_code) }
  it { is_expected.to be_delegated_to(driver, :liste_observations) }
  it { is_expected.to be_delegated_to(driver, :date_immatriculation) }
  it { is_expected.to be_delegated_to(driver, :date_immatriculation_timestamp) }
  it { is_expected.to be_delegated_to(driver, :date_extrait) }
end
