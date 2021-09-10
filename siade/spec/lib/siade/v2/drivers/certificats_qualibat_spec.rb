RSpec.describe SIADE::V2::Drivers::CertificatsQUALIBAT, :self_hosted_doc, type: :provider_driver do
  subject { described_class.new(siret: siret).perform_request }

  context 'siret inconnu chez QUALIBAT', vcr: { cassette_name: 'qualibat_with_not_found_siret' } do
    let(:siret) { not_found_siret(:qualibat) }

    its(:http_code) { is_expected.to eq(404) }
  end

  context 'siret eligible au certificat QUALIBAT', vcr: { cassette_name: 'qualibat_with_valid_siret' } do
    let(:siret) { valid_siret(:qualibat) }

    its(:http_code) { is_expected.to eq(200) }
    its(:document_url) { is_expected.to be_a_valid_self_hosted_pdf_url('certificat_qualibat') }

    context 'when an HTTP error occurs while retrieving the PDF' do
      describe 'Timeout error' do
        before { stub_request(:get, /www.qualibat.com/).to_timeout }

        its(:http_code) { is_expected.to eq(502) }
        its(:errors) { is_expected.to have_error('Temps d\'attente de téléchargement du document écoulé') }
      end

      describe 'OpenURI::HTTPError' do
        before { stub_request(:get, /www.qualibat.com/).to_return({ status: 502, body: 'Damn!' }) }

        its(:http_code) { is_expected.to eq(502) }
        its(:errors) { is_expected.to have_error('Erreur lors de la récupération du document : status 502 with body \'Damn!\'') }
      end
    end
  end

  context 'réponse 200 mais body empty de la part de QUALIBAT' do
    let(:siret) { '47882868400017' }

    before do
      url_pattern = %r{mps.qualibat.eu/MPS/CERTIFICAT/\?SIRET=#{siret}}
      stub_request(:get, url_pattern).to_return({
        status: 200,
        body: ''
      })
    end

    its(:http_code) { is_expected.to eq(502) }
    its(:errors) { is_expected.to have_error('L\'URL vers le document renvoyée par le fournisseur de données est invalide') }
  end
end
