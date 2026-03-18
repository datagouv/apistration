RSpec.describe SIADE::V2::Retrievers::Exercices do
  subject { described_class.new(valid_siret(:entreprise), options) }
  let(:options) {}
  let(:driver) { SIADE::V2::Drivers::Exercices }

  it { is_expected.to be_delegated_to(driver, :http_code) }
  it { is_expected.to be_delegated_to(driver, :liste_ca) }
end
