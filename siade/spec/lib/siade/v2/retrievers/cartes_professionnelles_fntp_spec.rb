RSpec.describe SIADE::V2::Retrievers::CartesProfessionnellesFNTP do
  subject { described_class.new(valid_siren(:fntp)) }

  let(:driver) { SIADE::V2::Drivers::CartesProfessionnellesFNTP }

  it { is_expected.to be_delegated_to(driver,  :http_code) }
  it { is_expected.to be_delegated_to(driver,  :document_url) }
end
