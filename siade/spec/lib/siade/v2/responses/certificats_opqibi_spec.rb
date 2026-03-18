RSpec.describe SIADE::V2::Responses::CertificatsOPQIBI, type: :provider_response do

  subject { SIADE::V2::Requests::CertificatsOPQIBI.new(siren).perform.response }

  context 'when siren is not found', vcr: { cassette_name: 'opqibi_with_non_existent_siren' } do
    let(:siren) { non_existent_siren }

    its(:class) { is_expected.to eq(SIADE::V2::Responses::ResourceNotFound) }
  end
end
