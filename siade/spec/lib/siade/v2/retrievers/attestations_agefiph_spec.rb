RSpec.describe SIADE::V2::Retrievers::AttestationsAGEFIPH do
  subject { described_class.new(valid_siret) }

  let(:one_and_only_driver) { SIADE::V2::Drivers::AttestationsAGEFIPH }

  it { is_expected.to be_delegated_to(one_and_only_driver,  :derniere_annee_de_conformite_connue) }
  it { is_expected.to be_delegated_to(one_and_only_driver,  :dump_date) }
  it { is_expected.to be_delegated_to(one_and_only_driver,  :success?) }
  it { is_expected.to be_delegated_to(one_and_only_driver,  :http_code) }
end
