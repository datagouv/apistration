RSpec.describe SIADE::V2::Retrievers::CertificatsAgenceBIO do
  subject { described_class.new(siret: valid_siret(:agence_bio)) }

  let(:driver) { SIADE::V2::Drivers::CertificatsAgenceBIO }

  it { is_expected.to be_delegated_to(driver, :http_code) }
  it { is_expected.to be_delegated_to(driver, :errors) }
  it { is_expected.to be_delegated_to(driver, :filtered_certifications_data) }
end
