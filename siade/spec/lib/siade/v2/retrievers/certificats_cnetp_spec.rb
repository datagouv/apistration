RSpec.describe SIADE::V2::Retrievers::CertificatsCNETP do
  subject { described_class.new(valid_siren(:cnetp)) }

  let(:one_and_only_driver) { SIADE::V2::Drivers::CertificatsCNETP }

  it { is_expected.to be_delegated_to(one_and_only_driver, :http_code) }
  it { is_expected.to be_delegated_to(one_and_only_driver, :document_url) }
end
