RSpec.describe QUALIBAT::CertificationsBatiment, :self_hosted_doc do
  subject { described_class.call(params:) }

  let(:params) do
    {
      siret:
    }
  end

  context 'when siret is valid', vcr: { cassette_name: 'qualibat/certifications_batiment/valid_siret' } do
    let(:siret) { valid_siret(:qualibat) }

    it { is_expected.to be_a_success }

    it 'sets the resource id' do
      expect(subject.resource.id).to eq(siret)
    end

    it 'uploads the certification on self storage' do
      certif_url = subject.resource.document_url

      expect(certif_url).to be_a_valid_self_hosted_pdf_url('certificat_qualibat')
    end
  end

  context 'when siret is not found', vcr: { cassette_name: 'qualibat/certifications_batiment/not_found_siret' } do
    let(:siret) { not_found_siret(:qualibat) }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to have_error('L\'identifiant indiqué n\'existe pas, n\'est pas connu ou ne comporte aucune information pour cet appel.') }
  end
end
