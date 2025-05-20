RSpec.describe CNETP::AttestationCotisationsCongesPayesChomageIntemperies, :self_hosted_doc, type: :retriever_organizer do
  subject { described_class.call(params:) }

  let(:params) do
    {
      siren:
    }
  end

  context 'when the attestation is found', vcr: { cassette_name: 'cnetp/attestation_cotisations_conges_payes_chomage_intemperies/valid_siren' } do
    let(:siren) { valid_siren(:cnetp) }

    it { is_expected.to be_success }

    it 'uploads the attestation on the self hosted storage' do
      document_url = subject.bundled_data.data.document_url

      expect(document_url).to be_a_valid_self_hosted_pdf_url('certificat_cnetp')
    end
  end

  context 'when the attestation is not found', vcr: { cassette_name: 'cnetp/attestation_cotisations_conges_payes_chomage_intemperies/not_found_siren' } do
    let(:siren) { not_found_siren }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to have_error('Le siret ou le siren indiqué n\'existe pas, n\'est pas connu ou ne comporte aucune information pour cet appel. Veuillez vérifier que votre recherche est couverte par le périmètre de l\'API.') }
  end
end
