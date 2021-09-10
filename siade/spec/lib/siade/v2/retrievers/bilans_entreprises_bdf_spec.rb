RSpec.describe SIADE::V2::Retrievers::BilansEntreprisesBDF do
  subject { described_class.new(valid_siren(:bilans_entreprises_bdf)) }

  let(:driver) { SIADE::V2::Retrievers::BilansEntreprisesBDF }

  before do
    allow_any_instance_of(SIADE::V2::Drivers::GenericDriver).to receive(:success?).and_return(true)
  end

  its(:bilans) { is_expected.not_to be_empty }

  it { is_expected.to be_delegated_to(driver, :http_code) }
  it { is_expected.to be_delegated_to(driver, :monnaie) }
  it { is_expected.to be_delegated_to(driver, :bilans) }
end
