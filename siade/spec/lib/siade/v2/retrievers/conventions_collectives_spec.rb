RSpec.describe SIADE::V2::Retrievers::ConventionsCollectives do
  subject { described_class.new(valid_siret(:conventions_collectives)) }

  let(:driver) { SIADE::V2::Drivers::ConventionsCollectives }

  it { is_expected.to be_delegated_to(driver, :http_code) }
  it { is_expected.to be_delegated_to(driver, :conventions) }
end
