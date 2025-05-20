RSpec.describe FNTP::CarteProfessionnelleTravauxPublics, :self_hosted_doc, type: :retriever_organizer do
  subject { described_class.call(params:) }

  let(:params) do
    {
      siren:
    }
  end

  context 'when the document is found', vcr: { cassette_name: 'fntp/carte_professionnelle_travaux_publics/valid_siren' } do
    let(:siren) { valid_siren(:fntp) }

    it { is_expected.to be_success }

    it 'uploads the attestation on the self hosted storage' do
      document_url = subject.bundled_data.data.document_url

      expect(document_url).to be_a_valid_self_hosted_pdf_url('carte_professionnelle_fntp')
    end
  end

  context 'when the document is not found', vcr: { cassette_name: 'fntp/carte_professionnelle_travaux_publics/not_found_siren' } do
    let(:siren) { not_found_siren }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to have_error('Le siret ou le siren indiqué n\'existe pas, n\'est pas connu ou ne comporte aucune information pour cet appel. Veuillez vérifier que votre recherche est couverte par le périmètre de l\'API.') }
  end
end
