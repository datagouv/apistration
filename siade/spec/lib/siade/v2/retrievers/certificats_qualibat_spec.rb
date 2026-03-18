RSpec.describe SIADE::V2::Retrievers::CertificatsQUALIBAT do
  subject { described_class.new(valid_siret(:qualibat)) }
  let(:one_and_only_driver) { SIADE::V2::Drivers::CertificatsQUALIBAT }

  it { is_expected.to be_delegated_to(one_and_only_driver, :http_code) }
  it { is_expected.to be_delegated_to(one_and_only_driver, :document_url) }
end
