RSpec.describe SIADE::V2::Retrievers::CertificatsOPQIBI do
  subject { described_class.new(valid_siren(:opqibi)) }

  let(:driver) { SIADE::V2::Drivers::CertificatsOPQIBI }

  it { is_expected.to be_delegated_to(driver, :http_code) }
  it { is_expected.to be_delegated_to(driver, :numero_certificat ) }
  it { is_expected.to be_delegated_to(driver, :date_de_delivrance_du_certificat ) }
  it { is_expected.to be_delegated_to(driver, :duree_de_validite_du_certificat ) }
  it { is_expected.to be_delegated_to(driver, :assurance ) }
  it { is_expected.to be_delegated_to(driver, :url) }
  it { is_expected.to be_delegated_to(driver, :qualifications) }
  it { is_expected.to be_delegated_to(driver, :date_de_validite_des_qualifications) }
  it { is_expected.to be_delegated_to(driver, :qualifications_probatoires) }
  it { is_expected.to be_delegated_to(driver, :date_de_validite_des_qualifications_probatoires) }
end
