RSpec.describe SIADE::V2::Requests::INPI::FindDocuments, type: :provider_request do
  subject { described_class.new(siren, :actes, valid_cookie_inpi).tap(&:perform) }

  context 'bad formated siren' do
    let(:siren) { invalid_siren }

    its(:valid?) { is_expected.to be_falsey }
    its(:http_code) { is_expected.to eq 422 }
    its(:errors) { are_expected.to have_error(invalid_siren_error_message) }
  end

  context 'non-existent siren', vcr: { cassette_name: 'inpi_actes_not_found' } do
    let(:siren) { not_found_siren(:inpi) }

    its(:valid?) { is_expected.to be_truthy }
    its(:http_code) { is_expected.to eq 404 }
    its(:errors) { are_expected.to have_error('Le siret ou siren indiqué n\'existe pas, n\'est pas connu ou ne comporte aucune information pour cet appel') }
  end

  context 'existing siret', vcr: { cassette_name: 'inpi_actes_valid_siren' } do
    let(:siren) { valid_siren(:inpi_pdf) }

    its(:valid?) { is_expected.to be_truthy }
    its(:http_code) { is_expected.to eq 200 }
    its(:errors) { are_expected.to be_empty }
    its(:response) { is_expected.to be_a(SIADE::V2::Responses::INPI::FindDocuments) }
  end
end
