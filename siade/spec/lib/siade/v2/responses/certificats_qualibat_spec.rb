RSpec.describe SIADE::V2::Responses::CertificatsQUALIBAT, type: :provider_response do
  subject { SIADE::V2::Requests::CertificatsQUALIBAT.new(siret).perform.response }

  context 'when siret is not found', vcr: { cassette_name: 'qualibat_with_not_found_siret' } do
    let(:siret) { not_found_siret(:qualibat) }

    its(:class) { is_expected.to eq(SIADE::V2::Responses::ResourceNotFound) }
  end
end
