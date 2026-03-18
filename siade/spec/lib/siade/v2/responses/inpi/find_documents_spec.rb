RSpec.describe SIADE::V2::Responses::INPI::FindDocuments, type: :provider_response do
  subject do
    SIADE::V2::Requests::INPI::FindDocuments
      .new(siren, :actes, valid_cookie_inpi)
      .tap(&:perform)
      .response
  end

  context 'when siren is not found', vcr: { cassette_name: 'inpi_actes_not_found' } do
    let(:siren) { not_found_siren(:inpi) }

    its(:http_code) { is_expected.to eq 404 }
  end

  context 'when siren is found', vcr: { cassette_name: 'inpi_actes_valid_siren' } do
    let(:siren) { valid_siren(:inpi_pdf) }

    its(:http_code) { is_expected.to eq 200 }
  end
end
