RSpec.describe SIADE::V2::Requests::CertificatsAgenceBIO, type: :provider_request do
  subject { described_class.new(siret).perform }

  context 'with a bad formated request' do
    let(:siret) { not_a_siret }

    its(:http_code) { is_expected.to eq(422) }
    its(:errors) { is_expected.to have_error(invalid_siret_error_message) }
  end

  context 'with a siret with currently active certifications', vcr: { cassette_name: 'agence_bio/with_valid_siret' } do
    let(:siret) { valid_siret(:agence_bio) }

    its(:http_code) { is_expected.to eq(200) }
    its(:errors) { is_expected.to be_empty }
  end

  context 'with siret having no currently active certifications', vcr: { cassette_name: 'agence_bio/with_not_found_siret' } do
    let(:siret) { not_found_siret(:agence_bio) }

    its(:http_code) { is_expected.to eq(404) }
    its(:errors) { is_expected.to have_error('Le siret ou siren indiqué n\'existe pas, n\'est pas connu ou ne comporte aucune information pour cet appel') }
  end

  context 'when Agence Bio responds with an error' do
    let(:siret) { valid_siret(:agence_bio) }

    before do
      url = 'https://back.agencebio.org/api/gouv/operateurs'
      stub_request(:get, /#{url}/)
        .to_return(
          status: 500,
          body: 'whatever'
        )
    end

    its(:http_code) { is_expected.to eq(502) }
    its(:errors) { is_expected.to have_error('Mauvaise réponse envoyée par le fournisseur de données') }
  end
end
