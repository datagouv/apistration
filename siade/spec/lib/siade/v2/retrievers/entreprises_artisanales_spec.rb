RSpec.describe SIADE::V2::Retrievers::EntreprisesArtisanales do
  subject { described_class.new(valid_siren(:rnm_cma)) }

  let(:driver) { SIADE::V2::Drivers::EntreprisesArtisanales }

  it { is_expected.to be_delegated_to(driver, :http_code) }
  it { is_expected.to be_delegated_to(driver, :entreprise) }
end
