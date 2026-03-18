RSpec.describe SIADE::V2::Retrievers::EORIDouanes do
  subject { described_class.new(valid_eori) }

  let(:driver) { SIADE::V2::Drivers::EORIDouanes }

  it { is_expected.to be_delegated_to(driver, :numero_eori) }
  it { is_expected.to be_delegated_to(driver, :actif) }
  it { is_expected.to be_delegated_to(driver, :raison_sociale) }
  it { is_expected.to be_delegated_to(driver, :rue) }
  it { is_expected.to be_delegated_to(driver, :ville) }
  it { is_expected.to be_delegated_to(driver, :code_postal) }
  it { is_expected.to be_delegated_to(driver, :pays) }
  it { is_expected.to be_delegated_to(driver, :code_pays) }
end
