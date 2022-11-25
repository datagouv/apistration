RSpec.describe SIADE::V2::Retrievers::DocumentsAssociations do
  subject { described_class.new('77567227221138') }

  let(:driver) { SIADE::V2::Drivers::Associations }

  it { is_expected.to be_delegated_to(driver, :nombre_documents) }
  it { is_expected.to be_delegated_to(driver, :documents) }

  describe 'provider returns an error', vcr: { cassette_name: 'non_regenerable/documents_associations_croix_rouge_error' } do
    before do
      subject.retrieve
      subject.success?
    end

    its(:http_code) { is_expected.to eq(502) }
    its(:errors) { is_expected.to have_error("La réponse retournée par le fournisseur de données est invalide et inconnue de notre service. L'équipe technique a été notifiée de cette erreur pour investigation.") }
  end
end
