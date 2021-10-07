RSpec.describe SIADE::V2::Retrievers::CertificatsRGEADEME do
  subject { described_class.new(siret: valid_siret(:rge_ademe)) }

  let(:driver) { SIADE::V2::Drivers::CertificatsRGEADEME }

  it { is_expected.to be_delegated_to(driver, :qualifications) }
  it { is_expected.to be_delegated_to(driver, :domaines) }
  it { is_expected.to be_delegated_to(driver, :http_code) }
  it { is_expected.to be_delegated_to(driver, :errors) }
end
